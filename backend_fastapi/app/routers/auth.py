from fastapi import APIRouter, Depends, HTTPException, status, Form
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from app.db.session import get_db
from app.crud.user import (
    get_user_by_email,
    get_user_by_phone,
    create_user,
    create_user_from_phone
)
from app.utils.security import verify_password, create_access_token, hash_password
from app.utils.redis_client import JWTBlacklist
from app.schemas.user import UserCreate, UserOut, PhoneRegister , PhoneLogin
from app.schemas.token import Token
from app.dependencies import get_current_user
from app.models.user import User


router = APIRouter(prefix="/auth", tags=["Auth"])  # 🔥 TEK ROUTER TANIMI

# ✅ Email ile login
@router.post("/login/email", response_model=Token)
def login_with_email(
    form_data: OAuth2PasswordRequestForm = Depends(),
    db: Session = Depends(get_db)
):
    user = get_user_by_email(db, form_data.username)
    if not user or not verify_password(form_data.password, user.password_hash):
        raise HTTPException(status_code=401, detail="Geçersiz e-posta veya şifre")

    access_token = create_access_token(data={"sub": user.email})
    return {"access_token": access_token, "token_type": "bearer"}


# ✅ Telefonla login (şifresiz)
@router.post("/login/phone", response_model=Token)
def login_with_phone(
    login_data: PhoneLogin,
    db: Session = Depends(get_db)
):
    print(f"📲 Telefon ile giriş isteği: {login_data.phone}")
    
    user = get_user_by_phone(db, login_data.phone)
    print(f"📲 Kullanıcı bulundu mu: {user is not None}")
    
    if not user:
        print("❌ Kullanıcı bulunamadı")
        raise HTTPException(status_code=401, detail="Telefon numarası bulunamadı")
    
    print(f"✅ Giriş başarılı: {user.name} {user.surname}")
    access_token = create_access_token(data={"sub": user.phone})
    print("🔐 Oluşturulan JWT Token:", access_token)
    return {"access_token": access_token, "token_type": "bearer"}


# ✅ E-mail ile kayıt
@router.post("/register/email", response_model=UserOut)
def register_email(user: UserCreate, db: Session = Depends(get_db)):
    existing_user = get_user_by_email(db, user.email)
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")

    created_user = create_user(db, user)
    return created_user


# ✅ Telefonla kayıt
@router.post("/register/phone")
def register_phone(user: PhoneRegister, db: Session = Depends(get_db)):
    existing_user = get_user_by_phone(db, user.phone)
    if existing_user:
        raise HTTPException(status_code=400, detail="Phone already registered")

    created_user = create_user_from_phone(db, user)
    return {"message": "User registered successfully", "user_id": created_user.id}

# ✅ Logout endpoint
@router.post("/logout")
async def logout(current_user: User = Depends(get_current_user)):
    """Kullanıcı logout olduğunda JWT token'ı kara listeye ekle"""
    try:
        # JWT token'ı kara listeye ekle (24 saat süreyle)
        # Not: Gerçek uygulamada token'ı request header'dan almak gerekir
        # Bu örnek için basit bir implementasyon
        await JWTBlacklist.add_to_blacklist(
            f"user_{current_user.id}_token", 
            expire_time=86400
        )
        return {"message": "Successfully logged out"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Logout failed: {str(e)}")
