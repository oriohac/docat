from django.db import models
from django.core.validators import RegexValidator
from django.contrib.auth.models import AbstractUser, User

class User(AbstractUser):
    first_name = models.CharField(max_length=50)
    last_name = models.CharField(max_length=50)
    email = models.EmailField(max_length=254)
    username = models.CharField(max_length=150, unique=True)
    phone_regex = RegexValidator(regex=r'^\+?1?\d{8,15}$', message="Phone Number Must Be entered in the form: +234123567890. up to 15 digits allowed.")
    phone = models.CharField(validators=[phone_regex], max_length=20, blank=True)
    password = models.CharField(max_length=100)
    confirm_password = models.CharField(max_length=100)
    created_at = models.DateTimeField(auto_now_add=True,  null=True)
    def __str__(self):
        return self.last_name
    class Meta:
        db_table = 'auth_user'

    


class Pets(models.Model):
    Dog = 'dg'
    Cat = 'ct'
    PET_CHOICES = {
        Dog : 'DOG',
        Cat : 'CAT'
    }
    STATE_CHOICES = {
        "ab":'ABIA',
        "ad":'ADAMAWA',
        "ak":'AKWA IBOM',
        "an":'ANAMBRA',
        "ba":'BAUCHI',
        "by":'BAYELSA',
        "be":'BENUE',
        "bo":'BORNO',
        "cr":'CROSS RIVER',
        "de":'DELTA',
        "eb":'EBONYI',
        "ed":'EDO',
        "ek":'EKITI',
        "en":'ENUGU',
        "go":'GOMBE',
        "im":'IMO',
        "ji":'JIGAWA',
        "kd":'KADUNA',
        "kn":'KANU',
        "kt":'KATSINA',
        "ke":'KEBBI',
        "ko":'KOGI',
        "kw":'KWARA',
        "la":'LAGOS',
        "na":'NASSARAWA',
        "ni":'NIGER',
        "og":'OGUN',
        "on":'ONDO',
        "os":'OSUN',
        "oy":'OYO',
        "pl":'PLATEAU',
        "ri":'RIVERS',
        "so":'SOKOTO',
        "ta":'TARABA',
        "yo":'YOBE',
        "za":'ZAMFARA',
        "fc":'ABUJA',
    }
    pettype = models.CharField(max_length=4,choices=PET_CHOICES,default='Which pet?')
    breed = models.CharField(max_length=50)
    amount = models.DecimalField( max_digits=12, decimal_places=2)
    description = models.TextField()
    location = models.CharField(max_length=20, choices=STATE_CHOICES, default='ab')