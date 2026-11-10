from django.contrib.auth.models import User
from django.db import models


# Create your models here.
class startup(models.Model):
    profile_image = models.CharField(max_length=100)
    email = models.CharField(max_length=100)
    company_name = models.CharField(max_length=100)
    website = models.CharField(max_length=500)
    linkedin = models.CharField(max_length=500)
    description = models.CharField(max_length=500)
    industry = models.CharField(max_length=100)
    location = models.CharField(max_length=100)
    funding_min = models.CharField(max_length=100)
    funding_max = models.CharField(max_length=100)
    funding_unit = models.CharField(max_length=100)
    team_size = models.CharField(max_length=100)
    status = models.CharField(max_length=100, default="pending")
    LOGIN=models.ForeignKey(User, on_delete=models.CASCADE)

class investor(models.Model):
    investor_name = models.CharField(max_length=100)
    org_name = models.CharField(max_length=100)
    profile_image = models.CharField(max_length=100)
    email = models.CharField(max_length=500)
    website = models.CharField(max_length=500)
    linkedin = models.CharField(max_length=500)
    bio = models.CharField(max_length=500)
    past_investments = models.CharField(max_length=100)
    preferred_industry = models.CharField(max_length=100)
    preferred_stage = models.CharField(max_length=100)
    investment_min = models.CharField(max_length=100)
    investment_max = models.CharField(max_length=100)
    investment_unit = models.CharField(max_length=100)
    location_preference = models.CharField(max_length=100)
    team_size = models.CharField(max_length=100)
    status = models.CharField(max_length=100, default="pending")
    LOGIN=models.ForeignKey(User, on_delete=models.CASCADE)

class liked(models.Model):
    date=models.CharField(max_length=100)
    type=models.CharField(max_length=100, default="investor")
    STARTUP = models.ForeignKey(startup, on_delete=models.CASCADE)
    INVESTOR = models.ForeignKey(investor, on_delete=models.CASCADE)

class saved(models.Model):
    date=models.CharField(max_length=100)
    type=models.CharField(max_length=100, default="investor")
    STARTUP = models.ForeignKey(startup, on_delete=models.CASCADE)
    INVESTOR = models.ForeignKey(investor, on_delete=models.CASCADE)

class chat(models.Model):
    date=models.CharField(max_length=100)
    message=models.CharField(max_length=100, default="investor")
    type=models.CharField(max_length=100, default="investor")
    STARTUP = models.ForeignKey(startup, on_delete=models.CASCADE)
    INVESTOR = models.ForeignKey(investor, on_delete=models.CASCADE)