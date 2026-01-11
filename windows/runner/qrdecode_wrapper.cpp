#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>
#include <gdiplus.h>
#include <vector>

using namespace Gdiplus;

// Конвертация PNG в IplImage через GDI+
IplImage* LoadPngToIpl(const std::vector<uint8_t>& pngBytes) {
    IStream* stream = nullptr;
    CreateStreamOnHGlobal(NULL, TRUE, &stream);
    ULONG written;
    stream->Write(pngBytes.data(), pngBytes.size(), &written);

    Bitmap bitmap(stream, FALSE);
    int width = bitmap.GetWidth();
    int height = bitmap.GetHeight();

    IplImage* img = cvCreateImage(cvSize(width, height), IPL_DEPTH_8U, 3);
    for(int y = 0; y < height; y++){
        for(int x = 0; x < width; x++){
            Color c;
            bitmap.GetPixel(x, y, &c);
            CvScalar s;
            s.val[0] = c.GetB();
            s.val[1] = c.GetG();
            s.val[2] = c.GetR();
            cvSet2D(img, y, x, s);
        }
    }
    stream->Release();
    return img;
}

// Метод для QR декодирования
std::string DecodeQRCode(const std::vector<uint8_t>& pngBytes) {
    IplImage* img = LoadPngToIpl(pngBytes);
    if(!img) return "";

    QrDecoderHandle decoder = qr_decoder_open();
    qr_decoder_decode_image(decoder, img, 16, 0);

    unsigned char buf[1024];
    int size = qr_decoder_get_body(decoder, buf, sizeof(buf));

    qr_decoder_close(decoder);
    cvReleaseImage(&img);

    return std::string((char*)buf, size);
}

// Метод для регистрации в MethodChannel
void RegisterQRChannel(flutter::FlutterViewController* controller) {
    auto messenger = controller->engine()->messenger();

    auto channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
        messenger,
        "windows_qr",
        &flutter::StandardMethodCodec::GetInstance()
    );

    channel->SetMethodCallHandler([](
        const flutter::MethodCall<flutter::EncodableValue>& call,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

        if (call.method_name() == "scanQRCode") {
            auto args = std::get<flutter::EncodableMap>(*call.arguments());
            auto dataEnc = std::get<std::vector<uint8_t>>(args[flutter::EncodableValue("imageData")]);

            std::string qrText = DecodeQRCode(dataEnc);
            result->Success(flutter::EncodableValue(qrText));
        } else {
            result->NotImplemented();
        }
    });

    controller->engine()->messenger()->SetChannel(std::move(channel));
}
