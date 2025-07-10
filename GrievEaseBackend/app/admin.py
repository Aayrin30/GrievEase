from django.contrib import admin
from .models import *
from django.utils.html import format_html

# Register your models here.


admin.site.register(Department)
admin.site.register(Course)
admin.site.register(Category)
admin.site.register(SupportStaff)
admin.site.register(Grievance)
admin.site.register(GrievImages)

class AdminUser(admin.ModelAdmin):
    list_display = ('firstName','lastName','phoneNo','email')  
    # readonly_fields = ('password',)
    
    def show_password(self, obj):
        return format_html(f"<code>{obj.password}</code>")
    
    show_password.short_description = "Hashed Password"

admin.site.register(Admin, AdminUser)

class FacultyUser(admin.ModelAdmin):
    list_display = ('firstName','lastName','phoneNo','email')  
    readonly_fields = ('password',) 
    
    def show_password(self, obj):
        return format_html(f"<code>{obj.password}</code>")
    
    show_password.short_description = "Hashed Password"

admin.site.register(Faculty, FacultyUser)

class StudentUser(admin.ModelAdmin):
    list_display = ('firstName','lastName','phoneNo','email')  
    readonly_fields = ('password',) 
    
    def show_password(self, obj):
        return format_html(f"<code>{obj.password}</code>")
    
    show_password.short_description = "Hashed Password"

admin.site.register(Student, FacultyUser)

class RoleClass(admin.ModelAdmin):
    list_display=('roleId','roleName')
    
admin.site.register(Role,RoleClass)
