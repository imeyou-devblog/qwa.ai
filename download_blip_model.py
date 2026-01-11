import torch
from transformers import Blip2Processor, Blip2ForConditionalGeneration
import onnxruntime as ort
import os

def download_blip_model():
    print("Downloading BLIP-2 model...")
    
    # Скачиваем модель и процессор
    processor = Blip2Processor.from_pretrained("Salesforce/blip2-opt-2.7b")
    model = Blip2ForConditionalGeneration.from_pretrained("Salesforce/blip2-opt-2.7b")
    
    # Создаем директорию для модели
    os.makedirs("models/blip2", exist_ok=True)
    
    # Сохраняем модель и процессор
    model.save_pretrained("models/blip2")
    processor.save_pretrained("models/blip2")
    
    print("Model downloaded successfully!")

if __name__ == "__main__":
    download_blip_model()