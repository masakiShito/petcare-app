from django.test import TestCase
from django.urls import reverse
from rest_framework.test import APIClient
from django.contrib.auth.models import User

class LoginAPITest(TestCase):
    def setUp(self):
        self.client = APIClient()
        # ユーザーが存在するか確認し、存在しない場合のみ作成
        if not User.objects.filter(username='masakishito').exists():
            self.user = User.objects.create_user(username='masakishito', password='pass')

    def test_login(self):
        url = reverse('login')
        data = {
            'username': 'masakishito',
            'password': 'pass'
        }
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, 200)
        self.assertIn('access', response.data)
        self.assertIn('refresh', response.data)
