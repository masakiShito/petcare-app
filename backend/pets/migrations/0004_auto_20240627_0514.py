# Generated by Django 3.2 on 2024-06-27 05:14

from django.db import migrations, models
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        ('pets', '0003_healthcheckupreminder_veterinarian'),
    ]

    operations = [
        migrations.CreateModel(
            name='PetFoodRecommendation',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('food_name', models.CharField(max_length=100)),
                ('recommended_for', models.CharField(max_length=100)),
            ],
        ),
        migrations.RemoveField(
            model_name='mealrecord',
            name='amount',
        ),
        migrations.RemoveField(
            model_name='mealrecord',
            name='created_at',
        ),
        migrations.RemoveField(
            model_name='mealrecord',
            name='meal_time',
        ),
        migrations.RemoveField(
            model_name='mealrecord',
            name='notes',
        ),
        migrations.RemoveField(
            model_name='mealrecord',
            name='updated_at',
        ),
        migrations.AddField(
            model_name='mealrecord',
            name='date',
            field=models.DateField(default=django.utils.timezone.now),
        ),
        migrations.AddField(
            model_name='mealrecord',
            name='quantity',
            field=models.DecimalField(decimal_places=2, default=0, max_digits=5),
        ),
        migrations.AlterField(
            model_name='mealrecord',
            name='food_type',
            field=models.CharField(default='', max_length=100),
        ),
    ]