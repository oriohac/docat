# Generated by Django 5.0.4 on 2024-05-17 07:43

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('docatapp', '0004_alter_pets_options_alter_pets_location_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='pets',
            name='pettype',
            field=models.CharField(choices=[('DOG', 'DOG'), ('CAT', 'CAT')], default='Other', max_length=5),
        ),
    ]