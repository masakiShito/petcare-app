from django.test import TestCase
from django.urls import reverse
from rest_framework.test import APIClient
from django.contrib.auth import get_user_model

User = get_user_model()

class LoginAPITest(TestCase):
    def setUp(self):
        self.client = APIClient()
        if not User.objects.filter(username='masakishito').exists():
            self.user = User.objects.create_user(email='masakishito@example.com', username='masakishito', password='password')
        self.client.force_authenticate(user=self.user)

    def test_login(self):
        url = reverse('token_obtain_pair')
        data = {
            'email': 'masakishito@example.com',  # ここでemailフィールドを使用
            'password': 'password'
        }
        response = self.client.post(url, data, format='json')
        print(response.data)  # レスポンスデータを出力して確認
        self.assertEqual(response.status_code, 200)
