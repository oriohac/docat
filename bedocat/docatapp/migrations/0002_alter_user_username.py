# Generated by Django 5.0.4 on 2024-04-17 16:11

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('docatapp', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='user',
            name='username',
            field=models.CharField(max_length=150, unique=True),
        ),
    ]
