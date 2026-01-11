#include "audio_checker.h"
#include <iostream>

bool AudioChecker::IsAudioPlaying() {
    HRESULT hr;
    bool isPlaying = false;

    // Initialize COM
    hr = CoInitialize(NULL);
    if (FAILED(hr)) return false;

    // Get device enumerator
    IMMDeviceEnumerator* pEnumerator = NULL;
    hr = CoCreateInstance(__uuidof(MMDeviceEnumerator), NULL,
        CLSCTX_ALL, __uuidof(IMMDeviceEnumerator),
        (void**)&pEnumerator);

    if (SUCCEEDED(hr)) {
        // Get default audio endpoint
        IMMDevice* pDevice = NULL;
        hr = pEnumerator->GetDefaultAudioEndpoint(eRender, eConsole, &pDevice);

        if (SUCCEEDED(hr)) {
            // Activate audio client
            IAudioClient* pAudioClient = NULL;
            hr = pDevice->Activate(__uuidof(IAudioClient), CLSCTX_ALL,
                NULL, (void**)&pAudioClient);

            if (SUCCEEDED(hr)) {
                // Get mix format
                WAVEFORMATEX* pMixFormat = NULL;
                hr = pAudioClient->GetMixFormat(&pMixFormat);

                if (SUCCEEDED(hr)) {
                    // Initialize audio client
                    hr = pAudioClient->Initialize(AUDCLNT_SHAREMODE_SHARED,
                        0, 10000000, 0, pMixFormat, NULL);

                    if (SUCCEEDED(hr)) {
                        // Get audio session manager
                        IAudioSessionManager2* pSessionManager = NULL;
                        hr = pAudioClient->GetService(__uuidof(IAudioSessionManager2),
                            (void**)&pSessionManager);

                        if (SUCCEEDED(hr)) {
                            // Get session enumerator
                            IAudioSessionEnumerator* pSessionEnumerator = NULL;
                            hr = pSessionManager->GetSessionEnumerator(&pSessionEnumerator);

                            if (SUCCEEDED(hr)) {
                                int sessionCount;
                                pSessionEnumerator->GetCount(&sessionCount);

                                for (int i = 0; i < sessionCount; i++) {
                                    IAudioSessionControl* pSessionControl = NULL;
                                    hr = pSessionEnumerator->GetSession(i, &pSessionControl);

                                    if (SUCCEEDED(hr)) {
                                        IAudioSessionControl2* pSessionControl2 = NULL;
                                        hr = pSessionControl->QueryInterface(__uuidof(IAudioSessionControl2),
                                            (void**)&pSessionControl2);

                                        if (SUCCEEDED(hr)) {
                                            AudioSessionState state;
                                            pSessionControl2->GetState(&state);

                                            if (state == AudioSessionStateActive) {
                                                isPlaying = true;
                                                pSessionControl2->Release();
                                                break;
                                            }
                                            pSessionControl2->Release();
                                        }
                                        pSessionControl->Release();
                                    }
                                }
                                pSessionEnumerator->Release();
                            }
                            pSessionManager->Release();
                        }
                    }
                    CoTaskMemFree(pMixFormat);
                }
                pAudioClient->Release();
            }
            pDevice->Release();
        }
        pEnumerator->Release();
    }

    CoUninitialize();
    return isPlaying;
}