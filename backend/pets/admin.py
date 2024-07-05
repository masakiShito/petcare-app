from django.contrib import admin
from .models import Pet  # .modelsはモデルが定義されているファイルのパスに置き換えてください

# PetモデルをDjango Adminに登録
admin.site.register(Pet)