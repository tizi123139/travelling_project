#include <iostream>
#include <string>
#include <cstdlib>   // 包含 _dupenv_s 需要的头文件
#include <curl/curl.h>
#include <nlohmann/json.hpp>

using json = nlohmann::json;

size_t WriteCallback(void* contents, size_t size, size_t nmemb, std::string* output) {
    size_t totalSize = size * nmemb;
    output->append((char*)contents, totalSize);
    return totalSize;
}

std::string callAliyun(const std::string& apiKey, const std::string& prompt) {
    CURL* curl = curl_easy_init();
    if (!curl) {
        throw std::runtime_error("初始化 CURL 失败");
    }

    std::string response;
    struct curl_slist* headers = nullptr;

    headers = curl_slist_append(headers, "Content-Type: application/json");
    headers = curl_slist_append(headers, ("Authorization: Bearer " + apiKey).c_str());

    json requestBody = {
        {"model", "qwen-turbo"},
        {"input", {
            {"messages", {
                {{"role", "user"}, {"content", prompt}}
            }}
        }},
        {"parameters", {
            {"temperature", 0.7},
            {"result_format", "message"}
        }}
    };
    std::string requestStr = requestBody.dump();

    curl_easy_setopt(curl, CURLOPT_URL, "https://dashscope.aliyuncs.com/api/v1/services/aigc/text-generation/generation");
    curl_easy_setopt(curl, CURLOPT_POST, 1L);
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, requestStr.c_str());
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response);
    curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 1L);

    CURLcode res = curl_easy_perform(curl);
    if (res != CURLE_OK) {
        curl_easy_cleanup(curl);
        curl_slist_free_all(headers);
        throw std::runtime_error("curl_easy_perform 失败: " + std::string(curl_easy_strerror(res)));
    }

    long httpCode = 0;
    curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &httpCode);
    if (httpCode != 200) {
        curl_easy_cleanup(curl);
        curl_slist_free_all(headers);
        throw std::runtime_error("HTTP 错误: " + std::to_string(httpCode) + "\n响应: " + response);
    }

    curl_easy_cleanup(curl);
    curl_slist_free_all(headers);
    return response;
}

std::string extractAliyunResponse(const std::string& response) {
    auto jsonResponse = json::parse(response);
    try {
        if (jsonResponse.contains("output") && jsonResponse["output"].contains("choices") &&
            !jsonResponse["output"]["choices"].empty()) {
            return jsonResponse["output"]["choices"][0]["message"]["content"].get<std::string>();
        }
        else if (jsonResponse.contains("output") && jsonResponse["output"].contains("text")) {
            return jsonResponse["output"]["text"].get<std::string>();
        }
        else {
            return "错误：无法解析响应\n" + response;
        }
    }
    catch (const std::exception& e) {
        return "解析响应时异常: " + std::string(e.what()) + "\n原始响应: " + response;
    }
}

int main() {
    // 使用安全的 _dupenv_s 获取环境变量
    char* apiKey = nullptr;
    size_t len = 0;
    errno_t err = _dupenv_s(&apiKey, &len, "ALIYUN_API_KEY");
    if (err != 0 || apiKey == nullptr) {
        std::cerr << "请设置环境变量 ALIYUN_API_KEY" << std::endl;
        return 1;
    }
    std::string apiKeyStr(apiKey);  // 转换为 std::string
    free(apiKey);                   // 释放 _dupenv_s 分配的内存

    std::string prompt;
    std::cout << "请输入你的问题：";
    std::getline(std::cin, prompt);

    try {
        std::string rawResponse = callAliyun(apiKeyStr, prompt);
        std::string answer = extractAliyunResponse(rawResponse);
        std::cout << "AI 回答：" << answer << std::endl;
    }
    catch (const std::exception& e) {
        std::cerr << "错误：" << e.what() << std::endl;
    }

    return 0;
}