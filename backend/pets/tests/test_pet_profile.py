from django.test import TestCase
from django.urls import reverse
from rest_framework.test import APIClient
from django.contrib.auth import get_user_model
from pets.models import Pet

User = get_user_model()

class PetProfileAPITest(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = User.objects.create_user(username='tempuser', password='temppass')
        self.client.force_authenticate(user=self.user)
        self.pet = Pet.objects.create(user=self.user, name='Buddy', species='Dog')

    def tearDown(self):
        self.pet.delete()
        self.user.delete()

    def test_get_pets(self):
        url = reverse('pet-list')  # URLパターン名を変更する必要があるかもしれません
        response = self.client.get(url, format='json')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data[0]['name'], 'Buddy')
    
    def test_create_pet(self):
        url = reverse('pet-list')
        data = {
            'name': 'Kitty',
            'species': 'Cat',
            'birthday': '2021-01-01',
            'gender': 'Female',
            'weight': 4.5,
            'height': 30.0
        }
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, 201)
        self.assertEqual(Pet.objects.count(), 2)
        self.assertEqual(Pet.objects.get(name='Kitty').species, 'Cat')
