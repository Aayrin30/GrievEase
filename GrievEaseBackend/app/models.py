from django.db import models
from django.contrib.auth.hashers import make_password,check_password
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
# Create your models here.

class Department(models.Model):
    deptId = models.IntegerField(primary_key=True,unique=True)
    deptName = models.CharField(max_length=15,null=True)
    
    def __str__(self):
        return self.deptName
    
class Role(models.Model):
    roleId=models.IntegerField(primary_key=True,unique=True)
    roleName=models.CharField(max_length=20,null=True)
    
    def __str__(self):
        return self.roleName
    
    
class Category(models.Model):
    categoryId=models.AutoField(primary_key=True,unique=True)
    categoryName=models.CharField(max_length=20,null=True)
    
    def __str__(self):
        return self.categoryName
    
    
class StudentManager(BaseUserManager):
    def create_user(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError("The Email field must be set")
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault("is_staff", True)
        extra_fields.setdefault("is_superuser", True)
        return self.create_user(email, password, **extra_fields)

class Student(AbstractBaseUser, PermissionsMixin):  # Add PermissionsMixin here
    studentId = models.AutoField(primary_key=True, unique=True)
    enrollmentNo = models.CharField(max_length=20, null=True)
    firstName = models.CharField(max_length=15, null=True)
    lastName = models.CharField(max_length=15, null=True)
    phoneNo = models.CharField(max_length=12, null=True)
    email = models.EmailField(max_length=20, unique=True, null=True)
    division = models.CharField(max_length=15, null=True)
    gender = models.CharField(max_length=10, null=True, choices=[('Male', 'Male'), ('Female', 'Female')])
    image = models.ImageField(upload_to='student_images/', null=True)
    password = models.CharField(max_length=256, null=True)
    # admissionDate = models.DateTimeField(null=True)
    role = models.ForeignKey('Role', null=True, blank=True, on_delete=models.SET_NULL)
    course = models.ForeignKey('Course', null=True, blank=True, on_delete=models.SET_NULL)

    # Add required fields for custom user model
    is_staff = models.BooleanField(default=False)
    is_superuser = models.BooleanField(default=False)

    objects = StudentManager()

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['firstName', 'lastName', 'studentId']

    def save(self, *args, **kwargs):
        if not self.password.startswith('pbkdf2_sha256$'):
            self.password = make_password(self.password)
        super().save(*args, **kwargs)

    def check_password(self, plain_password):
        return check_password(plain_password, self.password)

    def __str__(self):
        return self.firstName
    
class Faculty(models.Model):
    facultyId=models.AutoField(primary_key=True,unique=True)
    uniqueId=models.CharField(max_length=20,null=True)
    firstName=models.CharField(max_length=15,null=True)
    lastName=models.CharField(max_length=15,null=True)
    phoneNo=models.CharField(max_length=12,null=True)
    email=models.EmailField(max_length=20,null=True)
    password=models.CharField(max_length=256,null=True)
    gender=models.CharField(max_length=10,null=True, choices=[('Male', 'Male'), ('Female', 'Female')])
    image=models.ImageField(upload_to='faculty_images/',null=True)
    role=models.ForeignKey(Role,null=True,blank=True,on_delete=models.SET_NULL)
    course=models.ForeignKey('Course', null=True,blank=True,on_delete=models.SET_NULL)
    
    
    def save(self, *args, **kwargs):
        if not self.password.startswith('pbkdf2_sha256$'):
            self.password = make_password(self.password)
        super().save(*args, **kwargs)
        
    def check_password(self, plain_password):
        return check_password(plain_password,self.password)
    
    def __str__(self):
        return self.firstName
    

class SupportStaff(models.Model):
    staffId=models.AutoField(primary_key=True,unique=True)
    firstName=models.CharField(max_length=15,null=True)
    lastName=models.CharField(max_length=15,null=True)
    phoneNo=models.CharField(max_length=12,null=True)
    email=models.EmailField(max_length=20,null=True)
    designation=models.CharField(max_length=20,null=True)
    password=models.CharField(max_length=256,null=True)
    gender=models.CharField(max_length=10,null=True,  choices=[('Male', 'Male'), ('Female', 'Female')])
    image=models.ImageField(upload_to='staff_images/',null=True)
 
    def __str__(self):
        return self.firstName


class Admin(models.Model):
    adminId=models.AutoField(primary_key=True,unique=True)
    firstName=models.CharField(max_length=15,null=True)
    lastName=models.CharField(max_length=15,null=True)
    phoneNo=models.CharField(max_length=12,null=True)
    email=models.EmailField(max_length=20,null=True)
    password=models.CharField(max_length=256,null=True)
    gender=models.CharField(max_length=10,null=True,  choices=[('Male', 'Male'), ('Female', 'Female')])
    image=models.ImageField(upload_to='admin_images/',null=True)
    role=models.ForeignKey(Role,null=True,blank=True,on_delete=models.SET_NULL)
    department=models.ForeignKey(Department,null=True,blank=True,on_delete=models.SET_NULL)
    
    def save(self, *args, **kwargs):
        if not self.password.startswith('pbkdf2_sha256$'):
            self.password = make_password(self.password)
        super().save(*args, **kwargs)
        
    def check_password(self, plain_password):
        return check_password(plain_password,self.password)
    
    def __str__(self):
        return self.firstName
    
    
    
class Grievance(models.Model):
    user = models.ForeignKey(Student, on_delete=models.CASCADE, related_name="grievances")
    title = models.CharField(max_length=255)
    description = models.TextField()
    category = models.ForeignKey(Category, on_delete=models.CASCADE)
    status = models.CharField(max_length=50, default="Pending")  # Pending, In Progress, Resolved
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(null=True, blank=True)
    assigned_staff = models.ForeignKey('SupportStaff', on_delete=models.SET_NULL, null=True, blank=True, related_name='assigned_grievances')


    def __str__(self):
        return self.title

    @property
    def image_urls(self):
        return [img.images.url for img in self.grievance_images.all()]
    

class GrievImages(models.Model):
    grievance = models.ForeignKey(Grievance, on_delete=models.CASCADE, related_name="grievance_images")
    images = models.ImageField(upload_to='grievances/')

    def __str__(self):
        return f"Image for {self.grievance.title}"
    
class Course(models.Model):
    DURATION_CHOICES = [
        ('2 Years', '2 Years'),
        ('3 Years', '3 Years'),
        ('4 Years', '4 Years'),
        ('5 Years', '5 Years'),
    ]
        
    courseId=models.AutoField(primary_key=True,unique=True)
    deptId = models.ForeignKey(Department, null=True, blank=True, on_delete=models.SET_NULL)
    courseName=models.CharField(max_length=15,null=True)
    duration = models.CharField(max_length=7, choices=DURATION_CHOICES, null=True)  
    description = models.TextField(blank=True, null=True)
    coordinator=models.ForeignKey(Faculty, null=True, blank=True, on_delete=models.SET_NULL, related_name='coordinator')
    
    def __str__(self):
        return self.courseName

    