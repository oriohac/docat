
from django.urls import path
from .views import  create, delete, index, login, signup, list, signupApi, loginApi
from django.conf import settings
from django.conf.urls.static import static
from rest_framework.routers import DefaultRouter
app_name = name = 'docatapp'

urlpatterns = [
    path('',index,name='index'),
    path('list/',list, name='list'),
    path("signup/",signup,name='signup'),
    path('login/', login,name='login'),
    path('index/',index,name='index'),
    path('create/',create, name='view'),
    path('delete/<int:id>',delete,name='delete'),
    path('signupA/',signupApi,name='signup'),
    path('loginA/',loginApi,name='login')
]
urlpatterns += static(settings.MEDIA_URL,document_root=settings.MEDIA_ROOT)
