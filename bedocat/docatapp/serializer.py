from rest_framework import serializers
from .models import Pets, User
class PetSerializer(serializers.ModelSerializer):
    class Meta:
        model = Pets
        fields = '__all__'

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = '__all__'
        
    def create(self, validated_data):
        user = User.objects.create_user(
            username = validated_data['username'],
            password = validated_data['password'],
            email = validated_data['email'],
            first_name =['first_name'],
            last_name=['last_name'],
            phone=['phone'],
            confirm_password=['confirm_password']
        )
        return user