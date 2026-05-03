import json
from typing import Dict, Any
from dashscope import Generation

from app.core.config import settings
import uuid


class TravelPlanService:
    @staticmethod
    def generate_travel_plan(params: Dict[str, Any]) -> Dict[str, Any]:
        # ========== 核心修改1：解析多城市目的地 ==========
        destination = params['destination']
        destinations = [d.strip() for d in destination.split('/') if d.strip()]
        dest_desc = "、".join(destinations) if len(destinations) > 1 else destination

        # ========== 核心修改2：优化prompt，明确要求跨城市行程 ==========
        cross_city_prompt = ""
        if len(destinations) > 1:
            cross_city_prompt = f"""
            特别要求：
            1. 行程需要覆盖{dest_desc}所有城市，合理分配每天的目的地（比如前X天在{destinations[0]}，后Y天在{destinations[1]}）；
            2. itinerary 中的每个 day 对象需要明确标注当天所在城市，比如 content 开头注明「第1天（长沙）：...」；
            3. spots 字段只包含当天所在城市的景点，跨城市交通安排在 content 中描述；
            """

        prompt = f"""
        你是专业旅行规划师，严格按照以下要求返回数据：
        1. 仅返回标准 JSON 格式数据，无任何多余文字、Markdown、注释；
        2. JSON 结构必须和下方示例完全一致，字段名、类型不能改；
        3. itinerary 是数组，每个元素是独立的天数对象，day 为纯数字；
        4. spots 是字符串数组（注意是复数 spots）；
        5. hotel/food/tips 是字符串类型，多城市时需要分别推荐每个城市的内容。
        6. 新增字段 features：字符串数组，列出**2-4条本条旅行路线的亮点/特色/优点**。

        ------------------
        【最重要：content 字段必须是详细路线】
        content 必须包含：
        - 当天所在城市
        - 出发时间
        - 交通方式（步行/公交/地铁/打车/高铁）
        - 景点游玩顺序
        - 游玩时长
        - 用餐/休息安排
        不要只写景点名！要写成完整可执行的旅行路线！
        ------------------

        {cross_city_prompt}

        示例 JSON：
        {{
          "planId": "TP{uuid.uuid4().hex[:10]}",
          "destination": "{params['destination']}",
          "travelTime": {params['travelTime']},
          "travelCost": {params['travelCost']},
          "itinerary": [
            {{
              "day": 1,
              "content": "第1天（武汉）：早上8:00酒店出发，步行10分钟至黄鹤楼，游玩1.5小时；中午步行至户部巷品尝小吃；傍晚步行至长江大桥观赏夜景。",
              "spots": ["黄鹤楼", "户部巷", "长江大桥"]
            }},
            {{
              "day": 2,
              "content": "第2天（武汉）：上午乘坐地铁4号线至东湖，骑行绿道2小时；下午参观武汉大学；晚上前往楚河汉街逛街吃饭。",
              "spots": ["东湖", "武汉大学", "楚河汉街"]
            }}
          ],
          "features": ["景点丰富紧凑","交通便利省心","美食全覆盖","行程轻松不累"],
          "hotel": "武汉推荐：楚河汉街附近酒店",
          "food": "武汉美食：热干面、三鲜豆皮、小龙虾",
          "tips": "1. 武汉景点分散，尽量地铁出行；2. 夏季炎热注意防晒"
        }}


        用户需求：
        - 目的地：{dest_desc}
        - 天数：{params['travelTime']} 天
        - 预算：{params['travelCost']} 元
        - 目的：{params['travelPurpose']}
        - 要求：{params['detailedPlan']}
        
        """


        try:
            import dashscope
            from dashscope import Generation
            from app.core.config import settings

            dashscope.api_key = settings.DASHSCOPE_API_KEY

            response = Generation.call(
                model=settings.MODEL_NAME,
                messages=[{"role": "user", "content": prompt}],
                temperature=settings.TEMPERATURE,
                result_format="text",
                region_id="cn-hangzhou"
            )

            if response.status_code != 200:
                raise Exception(f"大模型调用失败：{response.message} (Request ID: {response.request_id})")

            if not response.output:
                raise Exception(f"大模型返回空输出 (Request ID: {response.request_id})")

            result_text = response.output.text.strip()
            if not result_text:
                raise Exception(f"大模型返回空文本 (Request ID: {response.request_id})")

            plan_data = json.loads(result_text)
            if not isinstance(plan_data, dict):
                raise Exception(f"大模型返回非字典数据：{type(plan_data)} (Request ID: {response.request_id})")

            plan_data.update({
                "destination": params["destination"],
                "travelTime": params["travelTime"],
                "travelCost": params["travelCost"]
            })

            return plan_data

        except json.JSONDecodeError as e:
            raise Exception(f"大模型返回非标准 JSON：{result_text}，错误：{str(e)}")
        except Exception as e:
            error_msg = str(e)
            if "Invalid API key" in error_msg or "apikey" in error_msg:
                raise Exception("API Key 无效，请检查 config.py 中的配置！")
            elif "JSON" in error_msg:
                raise Exception("大模型返回格式错误，无法解析为 JSON！")
            else:
                raise Exception(f"生成失败：{error_msg}")