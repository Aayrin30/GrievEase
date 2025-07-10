from django.shortcuts import render,redirect
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from GrievEaseBackend.settings import SECRET_KEY
from .models import *
from .serializers import *
from django.contrib.auth.hashers import make_password
from django.core.files.storage import default_storage
from django.http import JsonResponse
import jwt, datetime
import pandas as pd
import json
from django.views.decorators.csrf import csrf_exempt
import traceback
from rest_framework_simplejwt.tokens import RefreshToken

from rest_framework.decorators import api_view, parser_classes, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework.response import Response
from .models import Grievance, Category, GrievImages
from .serializers import GrievanceCreateSerializer
from django.contrib import messages

@api_view(['POST'])
@permission_classes([IsAuthenticated])
@parser_classes([MultiPartParser, FormParser])
def grievance_create(request):
    serializer = GrievanceCreateSerializer(data=request.data)
    print(serializer)
    if serializer.is_valid():
        user = request.user
        title = serializer.validated_data['title']
        description = serializer.validated_data['description']
        category_id = serializer.validated_data['category']
        images = request.FILES.getlist('images')
        
        # print(title, description, user)

        try:
            category = Category.objects.get(categoryId=category_id)
        except Category.DoesNotExist:
            return Response({'error': 'Invalid category ID'}, status=400)

        grievance = Grievance.objects.create(
            user=user,
            title=title,
            description=description,
            category=category
        )

        for img in images:
            GrievImages.objects.create(grievance=grievance, images=img)

        return Response({'message': 'Grievance submitted successfully'}, status=201)

    return Response(serializer.errors, status=400)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_categories(request):
    categories = Category.objects.all()
    serializer = CategorySerializer(categories, many=True)
    return Response(serializer.data)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def grievance_list(request):
    user = request.user
    grievance = Grievance.objects.filter(user=user)
    data = []
    for grievance in grievance:
        data.append({
            "title": grievance.title,
            "description": grievance.description,
            "category": grievance.category.categoryName,  # or grievance.category.id
            "status": grievance.status,
            "created_at": grievance.created_at.strftime("%Y-%m-%d"),
            "image_urls": grievance.image_urls  # uses @property
        })
    serializer = GrievanceFetchSerializer(data, many=True)
    # print(serializer.data)
    return Response(serializer.data)

# Create your views here.
def home(request):
    faculty_count = Faculty.objects.count()
    staff_count = SupportStaff.objects.count()
    griev_count = Grievance.objects.count()
    
    return render(request, 'index.html', {
        'faculty_count': faculty_count,
        'staff_count': staff_count,
        'griev_count' : griev_count
    })

def notFoundError(request):
    return render(request, '404.html')

def internalError(request):
    return render(request, '500.html')

def addStudent(request):
    courses = Course.objects.all()
    roles = Role.objects.all()

    if 'user_id' not in request.session:
        return redirect('login')
    
    admin = Admin.objects.get(adminId=request.session['user_id'])

    if request.method == 'POST':
        if 'excel_file' in request.FILES:  # Bulk upload
            excel_file = request.FILES['excel_file']
            file_path = default_storage.save(f'uploads/{excel_file.name}', excel_file)
            file_path = default_storage.path(file_path)

            try:
                df = pd.read_excel(file_path)
                df.columns = ['enrollmentNo', 'firstName', 'lastName', 'phoneNo', 'email', 'gender', 'role', 'course', 'password', 'division']

                errors = []

                for index, row in df.iterrows():
                    try:
                        courseobj = Course.objects.get(courseName=row['course'])
                        roleobj = Role.objects.get(roleName=row['role'])

                        if pd.isna(row['enrollmentNo']) or pd.isna(row['email']):
                            raise ValueError("Missing enrollmentNo or email.")

                        Student.objects.create(
                            enrollmentNo=row['enrollmentNo'],
                            firstName=row['firstName'],
                            lastName=row['lastName'],
                            phoneNo=row['phoneNo'],
                            email=row['email'],
                            gender=row['gender'],
                            division=row['division'],
                            role=roleobj,
                            course=courseobj,
                            password=make_password(row['password'])
                        )
                    except Exception as e:
                        error_msg = f"[Row {index + 2}] Error: {e}"
                        errors.append(error_msg)
                        print(error_msg)
                        traceback.print_exc()

                if errors:
                    print("\n=== Student Import Errors ===")
                    for err in errors:
                        print(err)
                    print("==============================\n")

                return redirect('students')

            except Exception as e:
                print("[General Excel Error]", e)
                traceback.print_exc()
                return redirect('students')

        else:  # Single student creation
            enrollmentno = request.POST['enrollmentno']
            firstname = request.POST['firstname']
            lastname = request.POST['lastname']
            phoneno = request.POST['phoneno']
            email = request.POST['email']
            gender = request.POST['gender']
            role = request.POST['role']
            division = request.POST['division']
            course = request.POST['course']
            password = request.POST['password']

            try:
                courseobj = Course.objects.get(courseName=course)
                roleobj = Role.objects.get(roleName=role)

                Student.objects.create(
                    enrollmentNo=enrollmentno,
                    firstName=firstname,
                    lastName=lastname,
                    phoneNo=phoneno,
                    email=email,
                    gender=gender,
                    role=roleobj,
                    division=division,
                    course=courseobj,
                    password=make_password(password)
                )
                return redirect('students')

            except Exception as e:
                print("[Single Student Creation Error]", e)
                traceback.print_exc()
                return redirect('students')

    return render(request, 'add-student.html', {
        'admin': admin,
        'courses': courses,
        'roles': roles,
    })

def courseDetails(request):
    return render(request, 'course-details.html')

def courses(request):
    if 'user_id' not in request.session:
        return redirect('login')

    admin = Admin.objects.get(adminId=request.session['user_id'])

    if request.method == 'POST':
        course_name = request.POST.get('courseName')
        duration = request.POST.get('duration')
        description = request.POST.get('courseDesc')
        coordinator_id = request.POST.get('coordinator')

        if course_name and duration and coordinator_id:
            try:
                coordinator = Faculty.objects.get(facultyId=coordinator_id)
                department = admin.department  # Assuming Admin has a ForeignKey to Department

                Course.objects.create(
                    deptId=department,
                    courseName=course_name,
                    duration=duration,
                    description=description,
                    coordinator=coordinator
                )
                messages.success(request, "Course added successfully!")
                return redirect('courses')  # Reload to avoid re-submission on refresh
            except Faculty.DoesNotExist:
                messages.error(request, "Selected coordinator does not exist.")
        else:
            messages.error(request, "Please fill all required fields.")

    # GET request or failed POST submission
    courses_list = Course.objects.all()
    faculty_list = Faculty.objects.all()
    
    return render(request, 'courses.html', {
        'courses': courses_list,
        'faculty': faculty_list,
        'admin': admin
    })
    
def assign_grievance(request, gid):
    grievance = Grievance.objects.get(id=gid)

    if request.method == 'POST':
        staff_id = request.POST.get('staff')
        print(staff_id)
        if staff_id:
            user = SupportStaff.objects.get(staffId=staff_id)
            print(user)
            grievance.assigned_staff = user
            grievance.save()
            return redirect('staff')  # or wherever you want

    return redirect('grievance')  # fallback or error case
    
def grievances(request):
    grievance = Grievance.objects.all()
    return render(request,'grievance.html',{'grievance':grievance})

def forgotPassword(request):
    return render(request, 'forgot-password.html')

def login(request):
    if request.method == 'POST':
        email = request.POST['email']
        password = request.POST['password']

        try:
            user = Admin.objects.get(email=email)
        except Admin.DoesNotExist:
            return render(request, 'login.html', {'error': 'Invalid email!'})

        if user.check_password(password): 
            request.session['user_id'] = user.adminId  
            request.session['user_name'] = user.firstName
            return redirect('home')  
        else:
            return render(request, 'login.html', {'error': 'Invalid password!'})

    return render(request, 'login.html')
    

def logout(request):
     request.session.flush()
     return redirect('login')
 
def professorDetails(request):
    return render(request, 'professor-details.html')

def professors(request):
    courses = Course.objects.all()
    roles = Role.objects.all()
    prof = Faculty.objects.all()

    if 'user_id' not in request.session:
        return redirect('login')
    
    admin = Admin.objects.get(adminId=request.session['user_id'])

    if request.method == 'POST':
        if 'excel_file' in request.FILES:  # Bulk upload
            excel_file = request.FILES['excel_file']
            file_path = default_storage.save(f'uploads/{excel_file.name}', excel_file)
            file_path = default_storage.path(file_path)

            try:
                df = pd.read_excel(file_path)
                df.columns = ['uniqueId', 'firstName', 'lastName', 'phoneNo', 'email', 'gender', 'role', 'course', 'password']

                errors = []

                for index, row in df.iterrows():
                    try:
                        courseobj = Course.objects.get(courseName=row['course'])
                        roleobj = Role.objects.get(roleName=row['role'])

                        # Basic field check (optional)
                        if pd.isna(row['uniqueId']) or pd.isna(row['email']):
                            raise ValueError("Missing uniqueId or email.")

                        Faculty.objects.create(
                            uniqueId=row['uniqueId'],
                            firstName=row['firstName'],
                            lastName=row['lastName'],
                            phoneNo=row['phoneNo'],
                            email=row['email'],
                            gender=row['gender'],
                            role=roleobj,
                            course=courseobj,
                            password=make_password(row['password'])
                        )
                    except Exception as e:
                        error_msg = f"[Row {index + 2}] Error: {e}"
                        errors.append(error_msg)
                        print(error_msg)
                        traceback.print_exc()

                if errors:
                    print("\n=== Faculty Import Errors ===")
                    for err in errors:
                        print(err)
                    print("==============================\n")

                return render(request, 'professors.html', {
                    'admin': admin,
                    'courses': courses,
                    'roles': roles,
                    'prof': prof
                })

            except Exception as e:
                print("[General Excel Error]", e)
                traceback.print_exc()
                return render(request, 'professors.html', {
                    'admin': admin,
                    'courses': courses,
                    'roles': roles,
                    'prof': prof
                })

        else:  # Single faculty account creation
            uniqueid = request.POST['uniqueId']
            firstname = request.POST['firstName']
            lastname = request.POST['lastName']
            phoneno = request.POST['phoneNo']
            email = request.POST['email']
            gender = request.POST['gender']
            role = request.POST['role']
            course = request.POST['course']
            password = request.POST['password']

            try:
                courseobj = Course.objects.get(courseName=course)
                roleobj = Role.objects.get(roleName=role)

                Faculty.objects.create(
                    uniqueId=uniqueid,
                    firstName=firstname,
                    lastName=lastname,
                    phoneNo=phoneno,
                    email=email,
                    gender=gender,
                    role=roleobj,
                    course=courseobj,
                    password=make_password(password)
                )
                return redirect('professors')

            except Exception as e:
                print("[Single Faculty Creation Error]", e)
                traceback.print_exc()
                return render(request, 'professors.html', {
                    'admin': admin,
                    'courses': courses,
                    'roles': roles,
                    'prof': prof
                })

    return render(request, 'professors.html', {
        'admin': admin,
        'courses': courses,
        'roles': roles,
        'prof': prof
    })
    
# @api_view(["POST"])
# def professorAppLogin(request):
#     print("Hello")
#     serializer = FacultyAppLoginSerializer(data=request.data)

#     if serializer.is_valid():
#         email = serializer.validated_data["email"]
#         password = serializer.validated_data["password"]

#         # Check if faculty exists
#         try:
#             faculty = Faculty.objects.get(email=email)
#             if faculty.check_password(password):
#                 # Generate JWT Token
#                 payload = {
#                     "user_id": faculty.facultyId,
#                     "email": faculty.email,
#                     "exp": datetime.datetime.utcnow() + datetime.timedelta(days=7),
#                 }
#                 token = jwt.encode(payload, SECRET_KEY, algorithm="HS256")
#                 return Response({"token": token, "message": "Login successful"}, status=status.HTTP_200_OK)
#             else:
#                 return Response({"error": "Invalid credentials"}, status=status.HTTP_400_BAD_REQUEST)
#         except Faculty.DoesNotExist:
#             return Response({"error": "User not found"}, status=status.HTTP_400_BAD_REQUEST)
        
#     return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(["POST"])
def professorAppLogin(request):
    # Print for debugging
    print("Hello")
    serializer = StudentLoginSerializer(data=request.data)

    if serializer.is_valid():
        email = serializer.validated_data["email"]
        password = serializer.validated_data["password"]

        # Check if faculty exists
        try:
            student = Student.objects.get(email=email)
            if student.check_password(password):
                # Generate JWT Token using SimpleJWT
                refresh = RefreshToken.for_user(student)
                access_token = str(refresh.access_token)  # Access token is included in the refresh token

                return Response(
                    {"token": access_token, "message": "Login successful"},
                    status=status.HTTP_200_OK,
                )
            else:
                return Response(
                    {"error": "Invalid credentials"}, status=status.HTTP_400_BAD_REQUEST
                )
        except Student.DoesNotExist:
            return Response(
                {"error": "User not found"}, status=status.HTTP_400_BAD_REQUEST
            )
        
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

def register(request):
    return render(request, 'register.html')

def staffDetails(request):
    return render(request, 'staff-details.html')

def staff(request):
    if 'user_id' not in request.session:
        return redirect('login')

    admin = Admin.objects.get(adminId=request.session['user_id'])
    roles = Role.objects.all()
    staff_list = SupportStaff.objects.all()

    if request.method == 'POST':
        if 'excel_file' in request.FILES:  # Bulk upload
            excel_file = request.FILES['excel_file']
            file_path = default_storage.save(f'uploads/{excel_file.name}', excel_file)
            file_path = default_storage.path(file_path)

            try:
                df = pd.read_excel(file_path)
                df.columns = ['firstName', 'lastName', 'phoneNo', 'email', 'designation', 'gender', 'password']
                errors = []

                for index, row in df.iterrows():
                    try:
                        if pd.isna(row['email']):
                            raise ValueError("Missing email.")

                        SupportStaff.objects.create(
                            firstName=row['firstName'],
                            lastName=row['lastName'],
                            phoneNo=str(row['phoneNo']),
                            email=row['email'],
                            designation=row['designation'],
                            gender=row['gender'],
                            password=make_password(str(row['password']))
                        )
                    except Exception as e:
                        error_msg = f"[Row {index + 2}] Error: {e}"
                        errors.append(error_msg)
                        print(error_msg)
                        traceback.print_exc()

                if errors:
                    print("\n=== Bulk Upload Errors ===")
                    for err in errors:
                        print(err)
                    print("================================\n")

                return redirect('staff')

            except Exception as e:
                print("[General Excel Error]", e)
                traceback.print_exc()

        else:  # Single staff creation
            firstname = request.POST['firstName']
            lastname = request.POST['lastName']
            phoneno = request.POST['phoneNo']
            email = request.POST['email']
            gender = request.POST['gender']
            designation = request.POST['designation']
            password = request.POST['password']

            try:

                SupportStaff.objects.create(
                    firstName=firstname,
                    lastName=lastname,
                    phoneNo=phoneno,
                    email=email,
                    gender=gender,
                    designation=designation,
                    password=make_password(password)
                )
                return redirect('staff')

            except Exception as e:
                print("[Single Staff Creation Error]", e)
                traceback.print_exc()

    return render(request, 'staff.html', {
        'admin': admin,
        'roles': roles,
        'staff_list': staff_list
    })

def studentDetails(request):
    return render(request, 'studentDetails.html')

def studentList(request, course_id):
    course = Course.objects.get(courseId=course_id)
    students = Student.objects.filter(course=course)
    return render(request, 'student-list.html', {'students': students, 'course': course})

def grievancelist(request,gid):
    grievance = Grievance.objects.get(id=gid)
    staff = SupportStaff.objects.all()
    return render(request,'grievancedetails.html',{'grievance': grievance, 'staff': staff})

def students(request):
    courses = Course.objects.all()
    return render(request, 'students.html', {'courses': courses})

