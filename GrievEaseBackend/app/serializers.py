from rest_framework import serializers
from .models import *

class StudentLoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)


class GrievanceCreateSerializer(serializers.Serializer):
    title = serializers.CharField(max_length=255)
    description = serializers.CharField()
    category = serializers.IntegerField()  # Static category ID from frontend
    images = serializers.ListField(
        child=serializers.ImageField(), required=False
    )
    
class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ['categoryId', 'categoryName'] 
        
class GrievanceFetchSerializer(serializers.Serializer):
    title = serializers.CharField()
    description = serializers.CharField()
    category = serializers.CharField()  # or IntegerField if you prefer ID
    status = serializers.CharField()
    created_at = serializers.CharField()
    image_urls = serializers.ListField(
        child=serializers.URLField(), required=False
    )