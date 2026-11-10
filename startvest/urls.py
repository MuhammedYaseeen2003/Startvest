"""
URL configuration for startvest project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import path

from myapp import views

urlpatterns = [
    path('admin/', admin.site.urls),

    path("landing", views.landing),
    path("", views.log),
    path("login_post", views.login_post),
    path("logoutt", views.logoutt),
    path("forgot", views.forgot),
    path("forgot_post", views.forgot_post),
    path("forgot_password", views.forgot_password),
    path("forgot_password_post", views.forgot_password_post),
    path("forgot_password3", views.forgot_password3),
    path("forgot_password3_post", views.forgot_password3_post),

    path("startup_reg", views.startup_reg),
    path("startup_reg_post", views.startup_reg_post),

    path("investor_reg", views.investor_reg),
    path("investor_reg_post", views.investor_reg_post),


    path("admin_home", views.admin_home),
    path("admin_view_investors", views.admin_view_investors),
    path("admin_approve_investors/<id>", views.admin_approve_investors),
    path("admin_reject_investors/<id>", views.admin_reject_investors),
    path("admin_view_investors_approved", views.admin_view_investors_approved),
    path("admin_reject_investors2/<id>", views.admin_reject_investors2),
    path("admin_view_investors_rejected", views.admin_view_investors_rejected),
    path("admin_approve_investors2/<id>", views.admin_approve_investors2),
    path("admin_view_startups", views.admin_view_startups),
    path("admin_approve_startups/<id>", views.admin_approve_startups),
    path("admin_reject_startups/<id>", views.admin_reject_startups),
    path("admin_view_startups_approved", views.admin_view_startups_approved),
    path("admin_reject_startups2/<id>", views.admin_reject_startups2),
    path("admin_view_startups_rejected", views.admin_view_startups_rejected),
    path("admin_approve_startups2/<id>", views.admin_approve_startups2),




    path("flutter_login", views.flutter_login),
    path("view_profile_inv", views.view_profile_inv),
    path("inv_change_password", views.inv_change_password),
    path("inv_view_startups", views.inv_view_startups),
    path("inv_like_startup", views.inv_like_startup),
    path("inv_save_startup_profile", views.inv_save_startup_profile),
    path("inv_view_liked_startups", views.inv_view_liked_startups),
    path("inv_dislike_startup", views.inv_dislike_startup),
    path("inv_view_saved_startups", views.inv_view_saved_startups),
    path("inv_remove_saved_startup", views.inv_remove_saved_startup),
    path("inv_sendchat", views.inv_sendchat),
    path("inv_viewchat", views.inv_viewchat),
    path("inv_view_interested_startups", views.inv_view_interested_startups),

    path("view_profile_startup", views.view_profile_startup),
    path("strt_change_password", views.strt_change_password),
    path("strt_view_investors", views.strt_view_investors),
    path("strt_view_interested_investors", views.strt_view_interested_investors),
    path("strt_sendchat", views.strt_sendchat),
    path("strt_viewchat", views.strt_viewchat),
    path("startup_view_inv_card", views.startup_view_inv_card),
    path("startup_like_investor", views.startup_like_investor),
    path("startup_save_inv_profile", views.startup_save_inv_profile),
    path("startup_view_liked_investors", views.startup_view_liked_investors),
    path("startup_dislike_inv", views.startup_dislike_inv),
    path("startup_view_saved_investors", views.startup_view_saved_investors),
    path("startup_remove_saved_inv", views.startup_remove_saved_inv),
    path("startup_reface_text", views.startup_reface_text),
]

urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
