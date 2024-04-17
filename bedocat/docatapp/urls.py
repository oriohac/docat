
from django.urls import path
from .views import index, login, signup

urlpatterns = [
    path('',login,name='login'),
    path("signup/",signup,name='signup'),
    path('login/', login,name='login'),
    path('index/',index,name="index")
]
