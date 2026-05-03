import json
import random
import time
from typing import List

from alibabacloud_dypnsapi20170525.client import Client as Dypnsapi20170525Client
from alibabacloud_credentials.client import Client as CredentialClient
from alibabacloud_tea_openapi import models as open_api_models
from alibabacloud_dypnsapi20170525 import models as dypnsapi_20170525_models
from alibabacloud_tea_util import models as util_models

# 临时存储验证码（生产环境建议用Redis）
code_storage = {}


class SmsService:
    def __init__(self):
        pass

    @staticmethod
    def create_client() -> Dypnsapi20170525Client:
        """
        初始化阿里云号码认证服务客户端（适配你的测试环境）
        """
        # 使用阿里云凭据认证（无需手动填AccessKey，自动读取环境/配置）
        access_key_id1 =
        access_key_secret1=
        config = open_api_models.Config(
            access_key_id=access_key_id1,
            access_key_secret=access_key_secret1,
            endpoint='dypnsapi.aliyuncs.com'
        )
        return Dypnsapi20170525Client(config)

    @staticmethod
    def generate_verify_code() -> str:
        """生成6位随机验证码"""
        return str(random.randint(100000, 999999))

    @staticmethod
    def send_sms_code(phone: str = "") -> str:
        """
        发送短信验证码（适配速通互联100001模板）
        :param phone: 测试手机号
        :return: 6位验证码
        """
        # 1. 生成验证码
        code = SmsService.generate_verify_code()

        # 2. 校验手机号（仅允许测试手机号）
        if phone != :
            raise ValueError("仅支持测试手机号：")

        # 3. 校验发送频率（60秒内只能发一次）
        if phone in code_storage and time.time() - code_storage[phone]["send_time"] < 60:
            raise ValueError("验证码发送太频繁，请60秒后再试")

        # 4. 调用阿里云号码认证服务发送短信
        client = SmsService.create_client()
        send_sms_request = dypnsapi_20170525_models.SendSmsVerifyCodeRequest(
            sign_name='速通互联验证码',  # 固定签名
            template_code='100001',  # 固定模板CODE
            phone_number=phone,  # 测试手机号
            template_param=f'{{"code":"{code}","min":"5"}}'  # 模板参数
        )
        runtime = util_models.RuntimeOptions()

        try:
            # 发送短信
            resp = client.send_sms_verify_code_with_options(send_sms_request, runtime)
            print(f"【响应状态】: {resp.status_code}")
            print(f"【响应体】: {json.dumps(resp.body.to_map(), indent=2, ensure_ascii=False)}")

            # 检查发送结果
            if resp.body.code != "OK":
                raise Exception(f"短信发送失败：{resp.body.message}")

            # 5. 存储验证码（5分钟有效期）
            code_storage[phone] = {
                "code": code,
                "send_time": time.time(),
                "expire_time": time.time() + 5 * 60
            }

            return code
        except Exception as error:
            print(f"发送异常：{error.message}")
            if error.data.get("Recommend"):
                print(f"解决方案：{error.data.get('Recommend')}")
            raise Exception(f"短信发送失败：{error.message}")

    @staticmethod
    def verify_code(phone: str, code: str) -> bool:
        """
        校验验证码是否正确/过期
        :param phone: 手机号
        :param code: 用户输入的验证码
        :return: 校验结果
        """
        # 1. 检查验证码是否存在
        if phone not in code_storage:
            return False

        record = code_storage[phone]

        # 2. 检查是否过期
        if time.time() > record["expire_time"]:
            del code_storage[phone]
            return False

        # 3. 检查验证码是否匹配
        if record["code"] != code:
            return False

        # 4. 验证通过，删除验证码（防止重复使用）
        del code_storage[phone]
        return True


# 测试代码（直接运行这个文件就能发验证码）
if __name__ == '__main__':
    try:
        send_code = SmsService.send_sms_code("13677284669")
        print(f"发送的验证码：{send_code}")
        # 测试校验
        verify_result = SmsService.verify_code("13677284669", send_code)
        print(f"验证码校验结果：{verify_result}")
    except Exception as e:
        print(f"测试失败：{e}")