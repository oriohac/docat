from django.shortcuts import redirect, render
from django.contrib import messages
from django.contrib.auth.models import User, auth
from django.contrib.auth import authenticate
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
            return redirect('index/')
        else:
            messages.warning(request,'check your credentials')
    else:
        return render(request,'login.html')
def index(request):
    return render(request,'index.html')