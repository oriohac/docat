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
    Dog = 'DOG'
    Cat = 'CAT'
    PET_CHOICES = {
        Dog : 'DOG',
        Cat : 'CAT'
    }
    STATE_CHOICES = {
        "ABIA":'ABIA',
        "ADAMAWA":'ADAMAWA',
        "AKWA IBOM":'AKWA IBOM',
        "ANAMBRA":'ANAMBRA',
        "BAUCHI":'BAUCHI',
        "BAYELSA":'BAYELSA',
        "BENUE":'BENUE',
        "BORNO":'BORNO',
        "CROSS RIVER":'CROSS RIVER',
        "DELTA":'DELTA',
        "EBONYI":'EBONYI',
        "EDO":'EDO',
        "EKITI":'EKITI',
        "ENUGU":'ENUGU',
        "GOMBE":'GOMBE',
        "IMO":'IMO',
        "JIGAWA":'JIGAWA',
        "KADUNA":'KADUNA',
        "KANO":'KANO',
        "KATSINA":'KATSINA',
        "KEBBI":'KEBBI',
        "KOGI":'KOGI',
        "KWARA":'KWARA',
        "LAGOS":'LAGOS',
        "NASSARAWA":'NASSARAWA',
        "NIGER":'NIGER',
        "OGUN":'OGUN',
        "ONDO":'ONDO',
        "OSUN":'OSUN',
        "OYO":'OYO',
        "PLATEAU":'PLATEAU',
        "RIVERS":'RIVERS',
        "SOKOTO":'SOKOTO',
        "TARABA":'TARABA',
        "YOBE":'YOBE',
        "ZAMFARA":'ZAMFARA',
        "ABUJA":'ABUJA',
    }
    petimage = models.ImageField(upload_to='images/',default='x')
    pettype = models.CharField(max_length=4,choices=PET_CHOICES,default='Which pet?')
    breed = models.CharField(max_length=50)
    amount = models.DecimalField( max_digits=12, decimal_places=2)
    description = models.TextField()
    location = models.CharField(max_length=20, choices=STATE_CHOICES, default='ab')
    def __str__(self):
        return self.breed +" "+ self.pettype + " " + self.location
    class Meta:
        verbose_name = "PET"
        verbose_name_plural = "PETS"