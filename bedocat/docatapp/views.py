from django.http import HttpResponseRedirect
from django.shortcuts import redirect, render
from django.contrib import messages
from django.contrib.auth.models import User, auth
from django.contrib.auth import authenticate
from django.urls import reverse
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import serializers,status
from rest_framework.authtoken.models import Token

from .serializer import PetSerializer, UserSerializer
from .models import Pets
# Create your views here.

def signup(request):
    if request.method == 'POST':
        firstname = request.POST['firstname']
        lastname = request.POST['lastname']
        email = request.POST['email']
        username = request.POST['username']
        phone = request.POST['phone']
        password = request.POST['password']
        confirm_password = request.POST['confirmpassword']
        if password == confirm_password:
            if User.objects.filter(email = email).exists():
                messages.info(request,"Email taken: Check Your Email")
                return redirect('signup/')
            elif User.objects.filter(username = username).exists():
                messages.info(request,"Username already taken")
                return redirect('signup/')
            else:
                User.objects.create_user(
                    firstname = firstname,
                    lastname = lastname,
                    email = email,
                    username = username,
                    phone = phone,
                    password = password,
                    confirm_password = confirm_password
                    ).save()
                return redirect('login/')
        else:
            messages.error(request,"Passwords don't match")
            return redirect('signup/')
    else:
        return render(request,'signup.html')
def login(request):
    if request.method == 'POST':
        username = request.POST['username']
        password =  request.POST['password']
        user = auth.authenticate(username = username, password = password)
        if user is not None:
            auth.login(request,user)
            return redirect('docatapp:index')
        else:
            messages.info(request,'check your credentials')
            return redirect('docatapp:login')
    else:
        return render(request,'login.html')

    
def index(request):
    pets = Pets.objects.all()
    return render(request,'index.html',context={'pets':pets})

def create(request):
    if request.method == 'POST':
        petimage = request.FILES['petimage']
        pettype = request.POST['pettype']
        breed = request.POST['breed']
        amount = request.POST['amount']
        description = request.POST['description']
        location = request.POST['location']
        if petimage and pettype and breed and amount and description and location is not None:
            pets = Pets(
               petimage=petimage,
               pettype=pettype,
               breed=breed,
               amount=amount,
               description=description,
               location = location
            )
            pets.save()
            return redirect('docatapp:index')
        else:
            messages.info(request, "fill all fields")
            return redirect('create/')
    else:
        return render(request,'create.html')
@api_view(['GET','POST'])
def delete(request, id):
    pets = Pets.objects.get(id=id)
    pets.delete()
    return redirect('docatapp:index')

@api_view(['GET','POST'])
def list(request):
    if request.method == 'GET':
        queryset = Pets.objects.all()
        serializer = PetSerializer(queryset,many=True)
        return Response(serializer.data)
    elif request.method == 'POST':
        serializer = PetSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data,status=status.HTTP_201_CREATED)
        return Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST)
    
@api_view(['GET','POST'])
def signupApi(request):
    serializer = UserSerializer(data=request.data)
    if serializer.is_valid():
        user = serializer.save()
        token, created = Token.objects.get_or_create(user=user)
        return Response({'token':token.key, 'success':'User created successfully'},status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET','POST'])
def loginApi(request):
    serializer = UserSerializer(data=request.data)
    if serializer.is_valid():
        user = authenticate(username=serializer.data['username'],password=serializer.data['password'])
        if user:
            token, createed = Token.objects.get_or_create(user=user)
            return Response({'token':token.key,'success':'Login Successful'}, status=status.HTTP_201_CREATED)
        return Response({'Message':'Invalid Username or Password'}, status=status.HTTP_404_NOT_FOUND)


