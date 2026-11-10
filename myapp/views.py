import datetime
import random
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.hashers import make_password
from django.contrib.auth.models import User, Group
from django.core.files.storage import FileSystemStorage
from django.http import HttpResponse, JsonResponse
from django.shortcuts import render

from myapp.text_refacer import reface_text_with_gemini
from .models import *

import smtplib
# Create your views here.

#   mail sending
#   mail_password = ""
app_mail="mainprojectgroup1vjec@gmail.com"
mail_password="Veststart2k25"
app_password="owsz ykhd ycfi oivw"
admin_mail="aavanikrishna85@gmail.com"

#   admin details
#   username : mainprojectgroup1vjec@gmail.com
#   password : superuser

print(make_password("Apple@123"))

media_path=r"C:\Users\aavan\OneDrive\Documents\project\startvest\media\\"

from django.core.validators import URLValidator
from django.core.exceptions import ValidationError
import requests
def validate_website_url(value):
    """
    Django form field validator for website URLs
    """
    # First, use Django's built-in URL validator
    validator = URLValidator()
    try:
        validator(value)
    except ValidationError:
        return False

    # Then check if website is accessible
    try:
        if not value.startswith(('http://', 'https://')):
            value = 'https://' + value

        response = requests.head(value, timeout=3, allow_redirects=True)
        return response.status_code < 400
    except:
        return False

def send_msg(rec_email, sub, msgg):
    s = smtplib.SMTP(host='smtp.gmail.com', port=587)
    s.starttls()
    s.login(app_mail, app_password)
    msg = MIMEMultipart()  # create a message.........."
    msg['From'] = app_mail
    msg['To'] = rec_email
    msg['Subject'] = sub
    body = msgg
    msg.attach(MIMEText(body, 'plain'))
    s.send_message(msg)
    return "ok"

def landing(request):
    return render(request, "landing_page.html")

def log(request):
    return render(request, "login.html")

def login_post(request):
    username=request.POST['email']
    password=request.POST['password']
    print(username, password)
    data=authenticate(request,username=username,password=password)
    print(data)
    if data is not None:
        login(request,data)
        if data.is_superuser:
            return HttpResponse("<script>alert('welcome admin');window.location='/admin_home';</script>")
        # elif data.groups.filter(name='startup').exists():
        #     return HttpResponse("<script>alert('You cant signup here. Please use app!!!');window.location='/';</script>")
        # elif data.groups.filter(name='investor').exists():
        #     request.session['inv_id']=startup.objects.get(LOGIN=request.user.id).id
        #     return HttpResponse("<script>alert('You cant signup here. Please use app!!!');window.location='/';</script>")
    else:
        return HttpResponse("<script>alert('Invalid details');window.location='/'</script>")

def logoutt(request):
    logout(request)
    return HttpResponse("<script>alert('Logout');window.location='/'</script>")


def startup_reg(request):
    return render(request, "startup_reg.html")

def startup_reg_post(request):
    img=request.FILES['profile-image']
    eml=request.POST['company-email']
    name=request.POST['company-name']
    website=request.POST['website']
    linkedin=request.POST['linkedin']
    description=request.POST['description']
    industry=request.POST['industry']
    location=request.POST['location']
    funding_min=request.POST['funding-min']
    funding_max=request.POST['funding-max']
    unit_display=request.POST['units']
    team_size=request.POST['team-size']
    signup_password=request.POST['signup-password']

    if validate_website_url(website):
        stat="approved"
    else:
        stat="pending"

    dt=datetime.datetime.now().strftime("%Y%m%d_%H%M%S") + ".jpg"
    fs=FileSystemStorage()
    fs.save(media_path + dt, img)
    path="/media/" + dt

    obj = User()
    obj.username = eml
    obj.password = make_password(signup_password)
    obj.save()
    obj.groups.add(Group.objects.get(name='startup'))

    obj1 = startup()
    obj1.profile_image = path
    obj1.email = eml
    obj1.company_name = name
    obj1.website = website
    obj1.linkedin = linkedin
    obj1.description = description
    obj1.industry = industry
    obj1.location = location
    obj1.funding_min = funding_min
    obj1.funding_max = funding_max
    obj1.funding_unit = unit_display
    obj1.team_size = team_size
    obj1.status = stat
    obj1.LOGIN = obj
    obj1.save()

    sub = "Startup registered"
    msg = "New statrtup registered in startvest website. Please login to your account for verifying the account."
    send_msg(admin_mail, sub, msg)
    return HttpResponse("<script>alert('Account created');window.location='/'</script>")


def investor_reg(request):
    return render(request, "investor_reg.html")

def investor_reg_post(request):
    img=request.FILES['profile-image']
    eml=request.POST['company-email']
    invname=request.POST['invname']
    orgname=request.POST['orgname']
    website=request.POST['website']
    linkedin=request.POST['linkedin']
    bio=request.POST['description']
    past_inv=request.POST['past_inv']
    industry=request.POST['industry']
    stage=request.POST['stage']
    location=request.POST['location']
    funding_min=request.POST['funding-min']
    funding_max=request.POST['funding-max']
    unit_display=request.POST['units']
    team_size=request.POST['team-size']
    signup_password=request.POST['signup-password']

    if validate_website_url(website):
        stat="approved"
    else:
        stat="pending"

    dt=datetime.datetime.now().strftime("%Y%m%d_%H%M%S") + ".jpg"
    fs=FileSystemStorage()
    fs.save(media_path + dt, img)
    path="/media/" + dt

    obj = User()
    obj.username = eml
    obj.password = make_password(signup_password)
    obj.save()
    obj.groups.add(Group.objects.get(name='investor'))

    obj1 = investor()
    obj1.profile_image = path
    obj1.email = eml
    obj1.investor_name = invname
    obj1.org_name = orgname
    obj1.website = website
    obj1.linkedin = linkedin
    obj1.bio = bio
    obj1.past_investments = past_inv
    obj1.preferred_industry = industry
    obj1.preferred_stage = stage
    obj1.location_preference = location
    obj1.investment_min = funding_min
    obj1.investment_max = funding_max
    obj1.investment_unit = unit_display
    obj1.team_size = team_size
    obj1.status = stat
    obj1.LOGIN = obj
    obj1.save()
    sub = "Startup registered"
    msg = "New investor registered in startvest website. Please login to your account for verifying the account."
    send_msg(admin_mail, sub, msg)
    return HttpResponse("<script>alert('Account created');window.location='/'</script>")


def forgot(request):
    return render(request, "forgot_password.html")

def forgot_post(request):
    email=request.POST['textfield']

    if User.objects.filter(username=email).exists():
        request.session['email']=email
        otp=random.randint(1000, 9999)
        sub="OTP for verification"
        msg="Your OTP for verification is " + str(otp) + ". Please provide this code in website to change your password."
        request.session['otp']=otp
        send_msg(email, sub, msg)
        return HttpResponse("<script>alert('OTP sent');window.location='/forgot_password'</script>")
    else:
        return HttpResponse("<script>alert('Email not registered');window.location='/forgot'</script>")


def forgot_password(request):
    return render(request,'forgot_password2.html')

def forgot_password_post(request):
    otp=request.POST['reset-code']
    if int(otp) == int(request.session['otp']):
        return HttpResponse("<script>alert('Email verified');window.location='/forgot_password3'</script>")
    else:
        return HttpResponse("<script>alert('Wrong OTP');window.location='/'</script>")

def forgot_password3(request):
    return render(request, 'forgot_password3.html')
def forgot_password3_post(request):
    password=request.POST['textfield']
    d = User.objects.get(username=request.session['email'])
    d.set_password(password)
    d.save()
    logout(request)
    return HttpResponse("<script>alert('Password changed');window.location='/'</script>")



###########             ADMIN
def admin_home(request):
    return render(request, "admin/admin_home.html")

def admin_view_investors(request):
    data=investor.objects.filter(status="pending")
    return render(request, "admin/view_investors_verify.html", {"data":data})

def admin_approve_investors(request, id):
    investor.objects.filter(id=id).update(status="approved")
    rec_mail=investor.objects.get(id=id).email
    sub = "Account approved"
    msg="Your account for StartVest App has been approved by admin. Please login to the system to continue."
    send_msg(rec_mail, sub, msg)
    return HttpResponse("<script>alert('Approved');window.location='/admin_view_investors#content'</script>")

def admin_reject_investors(request, id):
    investor.objects.filter(id=id).update(status="rejected")
    rec_mail=investor.objects.get(id=id).email
    sub = "Account rejected"
    msg="Your account for StartVest App has been rejected by admin."
    send_msg(rec_mail, sub, msg)
    return HttpResponse("<script>alert('Rejected');window.location='/admin_view_investors#content'</script>")

def admin_view_investors_approved(request):
    data=investor.objects.filter(status="approved")
    return render(request, "admin/view_investors_approved.html", {"data":data})

def admin_reject_investors2(request, id):
    investor.objects.filter(id=id).update(status="rejected")
    rec_mail=investor.objects.get(id=id).email
    sub = "Account rejected"
    msg="Your account for StartVest App has been rejected by admin."
    send_msg(rec_mail, sub, msg)
    return HttpResponse("<script>alert('Rejected');window.location='/admin_view_investors_approved#content'</script>")


def admin_view_investors_rejected(request):
    data=investor.objects.filter(status="rejected")
    return render(request, "admin/view_investors_rejected.html", {"data":data})

def admin_approve_investors2(request, id):
    investor.objects.filter(id=id).update(status="approved")
    rec_mail=investor.objects.get(id=id).email
    sub = "Account approved"
    msg="Your account for StartVest App has been approved by admin. Please login to the system to continue."
    send_msg(rec_mail, sub, msg)
    return HttpResponse("<script>alert('Approved');window.location='/admin_view_investors_rejected#content'</script>")



def admin_view_startups(request):
    data=startup.objects.filter(status="pending")
    return render(request, "admin/view_startups_verify.html", {"data":data})

def admin_approve_startups(request, id):
    startup.objects.filter(id=id).update(status="approved")
    rec_mail=startup.objects.get(id=id).email
    sub = "Account approved"
    msg="Your account for StartVest App has been approved by admin. Please login to the system to continue."
    send_msg(rec_mail, sub, msg)
    return HttpResponse("<script>alert('Approved');window.location='/admin_view_startups#content'</script>")

def admin_reject_startups(request, id):
    startup.objects.filter(id=id).update(status="rejected")
    rec_mail=startup.objects.get(id=id).email
    sub = "Account rejected"
    msg="Your account for StartVest App has been rejected by admin."
    send_msg(rec_mail, sub, msg)
    return HttpResponse("<script>alert('Rejected');window.location='/admin_view_startups#content'</script>")

def admin_view_startups_approved(request):
    data=startup.objects.filter(status="approved")
    return render(request, "admin/view_startups_approved.html", {"data":data})

def admin_reject_startups2(request, id):
    startup.objects.filter(id=id).update(status="rejected")
    rec_mail=startup.objects.get(id=id).email
    sub = "Account rejected"
    msg="Your account for StartVest App has been rejected by admin."
    send_msg(rec_mail, sub, msg)
    return HttpResponse("<script>alert('Rejected');window.location='/admin_view_startups_approved#content'</script>")


def admin_view_startups_rejected(request):
    data=startup.objects.filter(status="rejected")
    return render(request, "admin/view_startup_rejected.html", {"data":data})

def admin_approve_startups2(request, id):
    startup.objects.filter(id=id).update(status="approved")
    rec_mail=startup.objects.get(id=id).email
    sub = "Account approved"
    msg="Your account for StartVest App has been approved by admin. Please login to the system to continue."
    send_msg(rec_mail, sub, msg)
    return HttpResponse("<script>alert('Approved');window.location='/admin_view_startups_rejected#content'</script>")





#############   flutter

def flutter_login(request):
    username=request.POST['username']
    password=request.POST['password']
    print(username, password)
    data=authenticate(request,username=username,password=password)
    print(data)
    if data is not None:
        login(request,data)
        if data.groups.filter(name='startup').exists():
            stp_id=startup.objects.get(LOGIN=request.user.id).id
            stat=startup.objects.get(LOGIN=request.user.id).status
            if stat=="pending":
                return JsonResponse({"status":"no"})
            else:
                return JsonResponse({"status":"ok", "type":"startup", "sid":str(stp_id)})
        elif data.groups.filter(name='investor').exists():
            inv_id=investor.objects.get(LOGIN=request.user.id).id
            stat=investor.objects.get(LOGIN=request.user.id).status
            if stat=="pending":
                return JsonResponse({"status":"no"})
            else:
                return JsonResponse({"status":"ok", "type":"investor", "iid":str(inv_id)})
        else:
            return JsonResponse({"status": "no"})
    else:
        return JsonResponse({"status":"no"})



###############             investor
def inv_change_password(request):
    password = request.POST['oldpassword']
    newpassword = request.POST['newpassword']
    confirmpassword = request.POST['confirmpassword']
    iid = request.POST['iid']
    # print(password)
    v = investor.objects.get(id=iid)
    obj=authenticate(v.LOGIN.password, password)
    if obj:
        if confirmpassword == newpassword:
            a = v.LOGIN
            a.password=make_password(newpassword)
            a.save()
            return JsonResponse({"status": "password changed"})
        else:
            return JsonResponse({"status": "password mismatch"})
    else:
        return JsonResponse({"status": "invalid password"})

def view_profile_inv(request):
    data = investor.objects.filter(id=request.POST['iid'])
    ar = []
    for i in data:
        ar.append({"id": i.id,
                   "profile_image": i.profile_image,
                   "investor_name": i.investor_name,
                   "org_name": i.org_name,
                   "preferred_industry": i.preferred_industry,
                   "email": i.email,
                   "website": i.website,
                   "bio": i.bio,
                   })
    print(ar)
    return JsonResponse({"status": "ok", "data": ar})




#######     SIMILARITY MAIN
import re
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
import textdistance


def extract_features(description):
    """
    Extract key features from description text
    Returns: dictionary with category, min_funding, max_funding, team_size
    """
    features = {
        'category': None,
        'min_funding': None,
        'max_funding': None,
        'team_size': None,
        'original_text': description
    }

    try:
        # Extract category
        category_match = re.search(r'category\s+(\w+)', description, re.IGNORECASE)
        if category_match:
            features['category'] = category_match.group(1).lower()

        # Extract funding range
        funding_match = re.search(
            r'funding.*?range.*?(\d[\d,]*)\s*(?:Lakh|Lac|Cr|Crore)?\s*to\s*(\d[\d,]*)\s*(?:Lakh|Lac|Cr|Crore)?',
            description, re.IGNORECASE)
        if funding_match:
            min_fund = funding_match.group(1).replace(',', '')
            max_fund = funding_match.group(2).replace(',', '')
            features['min_funding'] = float(min_fund)
            features['max_funding'] = float(max_fund)

        # Extract team size
        team_match = re.search(r'team\s*size\s*(?:of|not above|below|up to)?\s*(\d+)', description, re.IGNORECASE)
        if team_match:
            features['team_size'] = int(team_match.group(1))

        return features

    except Exception as e:
        print(f"Error extracting features: {e}")
        return features


def calculate_text_similarity(text1, text2):
    """
    Calculate text similarity using multiple methods
    Returns: dictionary with different similarity scores
    """
    # Cosine similarity with TF-IDF
    vectorizer = TfidfVectorizer()
    tfidf_matrix = vectorizer.fit_transform([text1, text2])
    cosine_sim = cosine_similarity(tfidf_matrix[0:1], tfidf_matrix[1:2])[0][0]

    # Jaccard similarity
    words1 = set(text1.lower().split())
    words2 = set(text2.lower().split())
    intersection = words1.intersection(words2)
    union = words1.union(words2)
    jaccard_sim = len(intersection) / len(union) if union else 0

    # Levenshtein similarity (normalized)
    lev_distance = textdistance.levenshtein(text1, text2)
    max_len = max(len(text1), len(text2))
    levenshtein_sim = 1 - (lev_distance / max_len) if max_len > 0 else 1

    return {
        'cosine_similarity': cosine_sim,
        'jaccard_similarity': jaccard_sim,
        'levenshtein_similarity': levenshtein_sim,
        'combined_similarity': (cosine_sim + jaccard_sim + levenshtein_sim) / 3
    }


def calculate_feature_similarity(company_features, startup_features):
    """
    Calculate similarity based on extracted features
    """
    similarity_score = 0
    weights = {
        'category': 0.4,
        'funding': 0.4,
        'team_size': 0.2
    }

    # 1. Category similarity (exact match)
    if company_features['category'] and startup_features['category']:
        if company_features['category'] == startup_features['category']:
            similarity_score += weights['category']

    # 2. Funding compatibility score
    if (company_features['min_funding'] and company_features['max_funding'] and
            startup_features['min_funding'] and startup_features['max_funding']):

        # Check if funding ranges overlap
        company_range = (company_features['min_funding'], company_features['max_funding'])
        startup_range = (startup_features['min_funding'], startup_features['max_funding'])

        # Calculate overlap percentage
        overlap_min = max(company_range[0], startup_range[0])
        overlap_max = min(company_range[1], startup_range[1])

        if overlap_min <= overlap_max:
            # Ranges overlap
            overlap_length = overlap_max - overlap_min
            company_length = company_range[1] - company_range[0]
            startup_length = startup_range[1] - startup_range[0]

            # Average overlap percentage
            company_overlap = overlap_length / company_length if company_length > 0 else 0
            startup_overlap = overlap_length / startup_length if startup_length > 0 else 0
            funding_similarity = (company_overlap + startup_overlap) / 2

            similarity_score += funding_similarity * weights['funding']

    # 3. Team size compatibility
    if company_features['team_size'] and startup_features['team_size']:
        # For company: "team size not above X"
        # For startup: "team size of X"
        company_max_team = company_features['team_size']
        startup_team = startup_features['team_size']

        if startup_team <= company_max_team:
            # Perfect match if startup team is within company's limit
            similarity_score += weights['team_size']
        else:
            # Partial score based on how much over the limit
            penalty = min(1, (startup_team - company_max_team) / company_max_team)
            similarity_score += (1 - penalty) * weights['team_size']

    return similarity_score


def match_company_with_startups(company_requirement, startup_requirements):
    """
    Main function to match company requirement with startup requirements
    Returns: List of startups with similarity scores
    """
    results = []

    # Extract features from company requirement
    # Note: company_requirement is a tuple, take first element
    company_text = company_requirement[0] if isinstance(company_requirement, tuple) else company_requirement
    company_features = extract_features(company_text)

    print("Company Features:")
    print(f"  Category: {company_features['category']}")
    print(f"  Funding Range: {company_features['min_funding']} - {company_features['max_funding']}")
    print(f"  Max Team Size: {company_features['team_size']}")
    print("\n" + "=" * 50 + "\n")

    for startup in startup_requirements:
        # Extract features from startup description
        startup_text = startup['description']
        startup_features = extract_features(startup_text)

        # Calculate text similarity
        text_similarity = calculate_text_similarity(company_text, startup_text)

        # Calculate feature-based similarity
        feature_similarity = calculate_feature_similarity(company_features, startup_features)

        # Combined score (weighted average)
        text_weight = 0.3
        feature_weight = 0.7
        combined_score = (text_similarity['combined_similarity'] * text_weight +
                          feature_similarity * feature_weight)

        # Prepare result
        result = {
            'startup_id': startup['id'],
            'startup_description': startup_text,
            'text_similarity': text_similarity,
            'feature_similarity': feature_similarity,
            'overall_score': combined_score,
            'startup_features': startup_features
        }

        results.append(result)

    # Sort by overall score (descending)
    results.sort(key=lambda x: x['overall_score'], reverse=True)

    return results



def match_startup_with_investors(startup_requirement, company_requirement):
    """
    Main function to match company requirement with startup requirements
    Returns: List of startups with similarity scores
    """
    results = []

    # Extract features from company requirement
    # Note: company_requirement is a tuple, take first element
    startup_text = startup_requirement[0] if isinstance(startup_requirement, tuple) else startup_requirement
    startup_features = extract_features(startup_text)

    print("Statrup Features:")
    print(f"  Category: {startup_features['category']}")
    print(f"  Funding Range: {startup_features['min_funding']} - {startup_features['max_funding']}")
    print(f"  Max Team Size: {startup_features['team_size']}")
    print("\n" + "=" * 50 + "\n")

    for company in company_requirement:
        # Extract features from startup description
        company_text = company['description']
        company_features = extract_features(company_text)

        # Calculate text similarity
        text_similarity = calculate_text_similarity(company_text, startup_text)

        # Calculate feature-based similarity
        feature_similarity = calculate_feature_similarity(company_features, startup_features)

        # Combined score (weighted average)
        text_weight = 0.3
        feature_weight = 0.7
        combined_score = (text_similarity['combined_similarity'] * text_weight +
                          feature_similarity * feature_weight)

        # Prepare result
        result = {
            'company_id': company['id'],
            'company_description': company_text,
            'text_similarity': text_similarity,
            'feature_similarity': feature_similarity,
            'overall_score': combined_score,
            'company_features': company_features
        }

        results.append(result)

    # Sort by overall score (descending)
    results.sort(key=lambda x: x['overall_score'], reverse=True)

    return results


def print_results(results, top_n=5):
    """
    Print formatted results
    """
    print("MATCHING RESULTS:")
    print("=" * 80)

    for i, result in enumerate(results[:top_n], 1):
        print(f"\n#{i} - Startup ID: {result['startup_id']}")
        print(f"Overall Match Score: {result['overall_score']:.2%}")
        print(f"Feature Similarity: {result['feature_similarity']:.2%}")
        print(f"Text Similarity - Cosine: {result['text_similarity']['cosine_similarity']:.2%}")
        print(f"Text Similarity - Jaccard: {result['text_similarity']['jaccard_similarity']:.2%}")

        # Show extracted features
        sf = result['startup_features']
        print(f"Startup Category: {sf['category']}")
        print(f"Startup Funding Range: {sf['min_funding']} - {sf['max_funding']}")
        print(f"Startup Team Size: {sf['team_size']}")
        print(f"Description: {result['startup_description'][:100]}...")
        print("-" * 60)




def inv_view_startups(request):
    iid=request.POST['iid']
    inv_obj=investor.objects.get(id=iid)
    data = startup.objects.filter(status="approved")
    startup_requirements=[]
    company_requirement="This company requires startups from category " + inv_obj.preferred_industry + " requiring a funding in range of "\
             + inv_obj.investment_min + " " + inv_obj.investment_unit + " to " + inv_obj.investment_max + " " + inv_obj.investment_unit \
             + " with a team size not above" + inv_obj.team_size,
    for i in data:
        startup_requirements.append({
            "id": i.id,
             "description": "This company is from category " + i.industry + " having a funding requirement in range of "\
                            + i.funding_min + " " + i.funding_unit + " to " + i.funding_max + " " + i.funding_unit \
                            + " with a team size of " + i.team_size,

        })
    # Run the matching
    results = match_company_with_startups(company_requirement, startup_requirements)

    # Print top results
    print_results(results, top_n=len(results))

    print("Company requirement")
    print(company_requirement)
    print("*"*20)
    print("Startup requirement")
    print(startup_requirements)
    print("*"*20)
    ar = []
    for k in results:
        print("KK  ", k)
        print(k["startup_id"], k['overall_score'])
        i=startup.objects.get(id=k['startup_id'])
        data2=liked.objects.filter(STARTUP=i, INVESTOR_id=iid, type="investor")
        data3=saved.objects.filter(STARTUP=i, INVESTOR_id=iid, type="investor")
        sim_score=k['overall_score']
        if data2.exists():
            liked_stat="Liked"
        else:
            liked_stat = "Like"
        if data3.exists():
            saved_stat="Saved"
        else:
            saved_stat = "Save"
        ar.append({"id":i.id,
                 "profile_image": i.profile_image,
                 "company_name": i.company_name,
                 "industry": i.industry,
                 "location": i.location,
                 "email": i.email,
                 "website": i.website,
                 "description": i.description,
                 "liked_stat": liked_stat,
                 "saved_stat": saved_stat,
                 "sim_score": str(round(sim_score *100, 2))+"%",
                   })
    print(ar)
    return JsonResponse({"status": "ok", "data": ar})
def inv_like_startup(request):
    iid=request.POST['iid']
    startup_id=request.POST['startup_id']
    data = liked.objects.filter(STARTUP_id=startup_id, INVESTOR_id=iid, type="investor")
    if data.exists():
        data=data[0]
        data.delete()
        return JsonResponse({"status": "ok", "type":"disliked"})
    else:
        obj=liked()
        obj.date=datetime.datetime.now().date()
        obj.type="investor"
        obj.STARTUP_id=startup_id
        obj.INVESTOR_id=iid
        obj.save()
        return JsonResponse({"status": "ok", "type":"liked"})
def inv_save_startup_profile(request):
    iid=request.POST['iid']
    startup_id=request.POST['startup_id']
    data = saved.objects.filter(STARTUP_id=startup_id, INVESTOR_id=iid, type="investor")
    if data.exists():
        data=data[0]
        data.delete()
        return JsonResponse({"status": "ok", "type":"cancelled"})
    else:
        obj=saved()
        obj.date=datetime.datetime.now().date()
        obj.type="investor"
        obj.STARTUP_id=startup_id
        obj.INVESTOR_id=iid
        obj.save()
        return JsonResponse({"status": "ok", "type":"saved"})

def inv_view_liked_startups(request):
    iid = request.POST['iid']
    data = liked.objects.filter(type="investor", INVESTOR_id=iid)
    ar = []
    for i in data:
        ar.append({"id": i.id,
                   "sid": i.STARTUP.id,
                   "profile_image": i.STARTUP.profile_image,
                   "company_name": i.STARTUP.company_name,
                   "industry": i.STARTUP.industry,
                   "location": i.STARTUP.location,
                   "email": i.STARTUP.email,
                   "website": i.STARTUP.website,
                   "description": i.STARTUP.description,
                   })
    print(ar)
    return JsonResponse({"status": "ok", "data": ar})

def inv_sendchat(request):
    iid = request.POST['iid']
    to_id = request.POST['to_id']
    msg = request.POST['message']

    from  datetime import datetime
    c = chat()
    c.STARTUP_id = to_id
    c.INVESTOR_id = iid
    c.message = msg
    c.date = datetime.now()
    c.type = "investor"
    c.save()
    return JsonResponse({'status': "ok"})

def inv_viewchat(request):
    iid = request.POST['iid']
    to_id = request.POST['to_id']

    l = []
    data = chat.objects.filter(INVESTOR_id=iid, STARTUP_id=to_id).order_by('id')
    for res in data:
        l.append({'id': res.id, 'type': res.type, 'msg': res.message, 'date': res.date})
    return JsonResponse({'status': "ok", 'data': l})

def inv_dislike_startup(request):
    id = request.POST['id']
    liked.objects.filter(id=id).delete()
    return JsonResponse({"status": "ok"})

def inv_view_saved_startups(request):
    iid = request.POST['iid']
    data = saved.objects.filter(type="investor", INVESTOR_id=iid)
    ar = []
    for i in data:
        ar.append({"id": i.id,
                   "sid": i.STARTUP.id,
                   "profile_image": i.STARTUP.profile_image,
                   "company_name": i.STARTUP.company_name,
                   "industry": i.STARTUP.industry,
                   "location": i.STARTUP.location,
                   "email": i.STARTUP.email,
                   "website": i.STARTUP.website,
                   "description": i.STARTUP.description,
                   })
    print(ar)
    return JsonResponse({"status": "ok", "data": ar})

def inv_remove_saved_startup(request):
    id = request.POST['id']
    saved.objects.filter(id=id).delete()
    return JsonResponse({"status": "ok"})



def inv_view_interested_startups(request):
    iid=request.POST['iid']
    data = liked.objects.filter(type="startup", INVESTOR_id=iid)
    ar = []
    for i in data:
        ar.append({"id": i.id,
                   "iid": str(i.STARTUP.id),
                   "profile_image": i.STARTUP.profile_image,
                   "investor_name": i.STARTUP.company_name,
                   "industry": i.STARTUP.industry,
                   "email": i.STARTUP.email,
                   "website": i.STARTUP.website,
                   "bio": i.STARTUP.description,
                   })
    print("Hi", ar)
    return JsonResponse({"status": "ok", "data": ar})

##########          startup
def view_profile_startup(request):
    data=startup.objects.filter(id=request.POST['sid'])
    ar = []
    for i in data:
        ar.append({"id":i.id,
                 "profile_image": i.profile_image,
                 "company_name": i.company_name,
                 "industry": i.industry,
                 "location": i.location,
                 "email": i.email,
                 "website": i.website,
                 "description": i.description,
                 })
    print(ar)
    return JsonResponse({"status": "ok", "data": ar})

def strt_change_password(request):
    password = request.POST['oldpassword']
    newpassword = request.POST['newpassword']
    confirmpassword = request.POST['confirmpassword']
    iid = request.POST['iid']
    # print(password)
    v = investor.objects.get(id=iid)
    obj=authenticate(v.LOGIN.password, password)
    if obj:
        if confirmpassword == newpassword:
            a = v.LOGIN
            a.password=make_password(newpassword)
            a.save()
            return JsonResponse({"status": "password changed"})
        else:
            return JsonResponse({"status": "password mismatch"})
    else:
        return JsonResponse({"status": "invalid password"})

def strt_view_investors(request):
    sid=request.POST['sid']
    data = investor.objects.filter(status="approved")
    ar = []
    for i in data:
        ar.append({"id": i.id,
                   "profile_image": i.profile_image,
                   "investor_name": i.investor_name,
                   "org_name": i.org_name,
                   "past_investments": i.past_investments,
                   "email": i.email,
                   "website": i.website,
                   "bio": i.bio,
                   })
    print(ar)
    return JsonResponse({"status": "ok", "data": ar})


def strt_view_interested_investors(request):
    sid=request.POST['sid']
    data = liked.objects.filter(type="investor", STARTUP_id=sid)
    ar = []
    for i in data:
        ar.append({"id": i.id,
                   "iid": str(i.INVESTOR.id),
                   "profile_image": i.INVESTOR.profile_image,
                   "investor_name": i.INVESTOR.investor_name,
                   "org_name": i.INVESTOR.org_name,
                   "past_investments": i.INVESTOR.past_investments,
                   "email": i.INVESTOR.email,
                   "website": i.INVESTOR.website,
                   "bio": i.INVESTOR.bio,
                   })
    print("Hi", ar)
    return JsonResponse({"status": "ok", "data": ar})


def strt_sendchat(request):
    sid = request.POST['sid']
    to_id = request.POST['to_id']
    msg=request.POST['message']

    from  datetime import datetime
    c=chat()
    c.STARTUP_id=sid
    c.INVESTOR_id=to_id
    c.message=msg
    c.date=datetime.now()
    c.type="startup"
    c.save()
    return JsonResponse({'status':"ok"})

def strt_viewchat(request):
    sid=request.POST['sid']
    to_id=request.POST['to_id']

    l=[]
    data=chat.objects.filter(INVESTOR_id=to_id,STARTUP_id=sid).order_by('id')
    for res in data:
        l.append({'id':res.id,'type':res.type,'msg':res.message,'date':res.date})
    return JsonResponse({'status':"ok",'data':l})





########        new methods

def startup_view_inv_card(request):
    sid=request.POST['sid']
    strt_obj=startup.objects.get(id=sid)
    data = investor.objects.filter(status="approved")
    inv_requirements=[]
    strt_requirement="This startup requires investors looking for startups from category " + strt_obj.industry + " having a funding range of "\
             + strt_obj.funding_min + " " + strt_obj.funding_unit + " to " + strt_obj.funding_max + " " + strt_obj.funding_unit \
             + " looking for a team size not above" + strt_obj.team_size,
    for i in data:
        inv_requirements.append({
            "id": i.id,
             "description": "This investor is looking for startups from category " + i.preferred_industry + " having a funding requirement in range of "\
                            + i.investment_min + " " + i.investment_unit + " to " + i.investment_max + " " + i.investment_unit \
                            + " with a team size of " + i.team_size,

        })
    # Run the matching
    results = match_startup_with_investors(strt_requirement, inv_requirements)

    # Print top results
    # print_results(results, top_n=len(results))

    print("Startup requirement")
    print(strt_requirement)
    print("*"*20)
    print("Investor requirement")
    print(inv_requirements)
    print("*"*20)
    ar = []
    for k in results:
        print("KK  ", k)
        print(k["company_id"], k['overall_score'])
        i=investor.objects.get(id=k['company_id'])
        data2=liked.objects.filter(STARTUP_id=sid, INVESTOR_id=i, type="startup")
        data3=saved.objects.filter(STARTUP_id=sid, INVESTOR_id=i, type="startup")
        sim_score=k['overall_score']
        if data2.exists():
            liked_stat="Liked"
        else:
            liked_stat = "Like"
        if data3.exists():
            saved_stat="Saved"
        else:
            saved_stat = "Save"
        ar.append({"id":i.id,
                 "profile_image": i.profile_image,
                 "company_name": i.investor_name,
                 "industry": i.preferred_industry,
                 "location": i.location_preference,
                 "email": i.email,
                 "website": i.website,
                 "description": i.bio,
                 "liked_stat": liked_stat,
                 "saved_stat": saved_stat,
                 "sim_score": str(round(sim_score *100, 2))+"%",
                   })
    print(ar)
    return JsonResponse({"status": "ok", "data": ar})

def startup_like_investor(request):
    iid=request.POST['iid']
    startup_id=request.POST['startup_id']
    data = liked.objects.filter(STARTUP_id=startup_id, INVESTOR_id=iid, type="startup")
    if data.exists():
        data=data[0]
        data.delete()
        return JsonResponse({"status": "ok", "type":"disliked"})
    else:
        obj=liked()
        obj.date=datetime.datetime.now().date()
        obj.type="startup"
        obj.STARTUP_id=startup_id
        obj.INVESTOR_id=iid
        obj.save()
        return JsonResponse({"status": "ok", "type":"liked"})

def startup_save_inv_profile(request):
    iid=request.POST['iid']
    startup_id=request.POST['startup_id']
    data = saved.objects.filter(STARTUP_id=startup_id, INVESTOR_id=iid, type="startup")
    if data.exists():
        data=data[0]
        data.delete()
        return JsonResponse({"status": "ok", "type":"cancelled"})
    else:
        obj=saved()
        obj.date=datetime.datetime.now().date()
        obj.type="startup"
        obj.STARTUP_id=startup_id
        obj.INVESTOR_id=iid
        obj.save()
        return JsonResponse({"status": "ok", "type":"saved"})

def startup_view_liked_investors(request):
    sid = request.POST['sid']
    print(sid)
    data = liked.objects.filter(type="startup", STARTUP_id=sid)
    ar = []
    for i in data:
        ar.append({"id": i.id,
                   "sid": i.INVESTOR.id,
                   "profile_image": i.INVESTOR.profile_image,
                   "company_name": i.INVESTOR.investor_name,
                   "industry": i.INVESTOR.preferred_industry,
                   "location": i.INVESTOR.location_preference,
                   "email": i.INVESTOR.email,
                   "website": i.INVESTOR.website,
                   "description": i.INVESTOR.bio,
                   })
    print(ar)
    return JsonResponse({"status": "ok", "data": ar})

def startup_dislike_inv(request):
    id = request.POST['id']
    liked.objects.filter(id=id).delete()
    return JsonResponse({"status": "ok"})


def startup_view_saved_investors(request):
    sid = request.POST['sid']
    data = saved.objects.filter(type="startup", STARTUP_id=sid)
    ar = []
    for i in data:
        ar.append({"id": i.id,
                   "sid": i.INVESTOR.id,
                   "profile_image": i.INVESTOR.profile_image,
                   "company_name": i.INVESTOR.investor_name,
                   "industry": i.INVESTOR.preferred_industry,
                   "location": i.INVESTOR.location_preference,
                   "email": i.INVESTOR.email,
                   "website": i.INVESTOR.website,
                   "description": i.INVESTOR.bio,
                   })
    print(ar)
    return JsonResponse({"status": "ok", "data": ar})

def startup_remove_saved_inv(request):
    id = request.POST['id']
    saved.objects.filter(id=id).delete()
    return JsonResponse({"status": "ok"})

def startup_reface_text(request):
    txt=request.POST['message']
    ref_text=reface_text_with_gemini(txt)
    if ref_text !="":
        return JsonResponse({"status":"ok", "txt":ref_text})
    else:
        return JsonResponse({"status":"ok"})