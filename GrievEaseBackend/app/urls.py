"""
URL configuration for GrievEaseBackend project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.1/topics/http/urls/
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
from django.contrib import admin
from django.urls import path, include
from .import views

urlpatterns = [
    # Web admin Url's
    path('', views.home, name='home'),
    path('university/404', views.notFoundError, name='NotFound'),
    path('university/500', views.internalError, name='InternalServerError'),
    path('university/add-student', views.addStudent, name='add-student'),
    path('university/course-details', views.courseDetails, name='course-details'),
    path('university/courses', views.courses, name='courses'),
    path('university/forgot-password', views.forgotPassword, name='forgot-password'),
    path('university/login', views.login, name='login'),
    path('university/logout', views.logout, name='logout'),
    path('university/professor-details', views.professorDetails, name='professor-details'),
    path('university/professors', views.professors, name='professors'),
    path('university/register', views.register, name='register'),
    path('university/staff-details', views.staffDetails, name='staff-details'),
    path('university/staff', views.staff, name='staff'),
    path('university/student-details', views.studentDetails, name='student-details'),
    path('university/student-list/<int:course_id>', views.studentList, name='student-list'),
    path('university/students', views.students, name='students'),
    path('university/grievance', views.grievances, name='grievance'),
    path('university/grievancelist/<int:gid>', views.grievancelist, name='grievancelist'),
    path('university/assign_grievance/<int:gid>', views.assign_grievance, name='assign_grievance'),
    path('faculty/login',views.professorAppLogin, name='professorapplogin'),
    path('faculty/categories/', views.get_categories, name='categories'),
    path('faculty/grievance/',views.grievance_create, name='grievancesubmission'),
    path('api/grievances/',views.grievance_list, name='Grievances'),
    
]
