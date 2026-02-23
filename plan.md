# AI Recipe Assistant - Uygulama Plani (MVP)

## 1. Hedef ve Basari Kriteri
- 7 gun icinde calisan bir MVP cikarmak.
- Flutter mobil uygulamadan:
  - metinle malzeme girisi,
  - fotograf ile malzeme algilama,
  - AI destekli tarif uretimi calismali.
- Node.js API + Firestore ile veri akisi saglanmali.
- Next.js dashboard Firestore'dan okuyup en az 3 metrik gorsellestirmeli.
- Tum proje README uzerinden lokal olarak calistirilabilir olmali.

## 2. Kapsam ve Sinirlar (Bilincli Olarak)
- Yok: auth, profil, rol, production-grade guvenlik, deployment pipeline.
- Var: yalin ama saglam hata yonetimi, loading durumlari, tutarli veri modeli.
- Odak: "calisan urun + kararlarini aciklayabilme + canli oturumda hizli degisiklik yapabilme".

## 3. Teknik Yaklasim (Onerilen)
- Mobile: Flutter + BLoC (flutter_bloc) (event/state akisi net, canli oturumda debug etmesi kolay).
- Backend: Node.js + Express (tek API servisi).
- Database: Firebase Firestore.
- AI: Vision destekli model (OpenAI veya Gemini).
- Dashboard: Next.js tek sayfa + chart kutuphanesi (Recharts/Chart.js).

## 4. Firestore Veri Modeli (MVP Taslagi)
- `recipe_requests`
  - `id`
  - `createdAt`
  - `inputType` (`text` | `image` | `mixed`)
  - `rawIngredientsText`
  - `recognizedIngredients` (array)
  - `status` (`success` | `failed`)
  - `errorCode` (opsiyonel)
- `recipes`
  - `id`
  - `requestId` (recipe_requests referansi)
  - `name`
  - `ingredients` [{ `name`, `quantity`, `unit` }]
  - `steps` (array)
  - `prepTimeMinutes`
  - `difficulty` (`easy` | `medium` | `hard`)
  - `createdAt`
- `analytics_daily` (opsiyonel pre-aggregate, zaman kalirsa)
  - `date`
  - `generationCount`
  - `topIngredients`

## 5. API Endpoint Plani
- `POST /api/ingredients/recognize`
  - Girdi: image (base64 veya multipart)
  - Cikti: `recognizedIngredients[]`
- `POST /api/recipes/generate`
  - Girdi: `ingredients[]`, opsiyonel notlar
  - Cikti: tarif objesi (isim, malzemeler, adimlar, sure, zorluk)
- `GET /api/analytics/summary`
  - Cikti: dashboard grafik datalari
- `GET /api/health`
  - Basit saglik kontrolu

## 6. Prompt ve AI Cikti Stratejisi
- Tek format zorunlulugu: AI'dan sadece JSON donmesi istenecek.
- JSON schema backend tarafinda validate edilecek.
- Malzeme algilama prompt'u ve tarif prompt'u ayrilacak.
- Basarisiz parse durumunda:
  - 1 kez otomatik retry,
  - sonra kullaniciya anlasilir hata mesaji.

## 7. Mobil Uygulama Ekranlari (Minimum)
- `IngredientInputScreen`
  - Metin alani
  - Kamera/galeri secimi
  - "Malzemeleri Algila" ve "Tarif Uret" aksiyonlari
- `RecipeResultScreen`
  - Tarif adi
  - Malzeme listesi (miktarli)
  - Adim adim yapilis
  - Hazirlama suresi + zorluk seviyesi
- `Error/Empty/Loading states`
  - Bos giris uyari
  - Network/AI hatasi icin kullanici dostu mesaj

## 8. Flutter Mimari Plani (BLoC + Feature First)
- Mimari: `presentation` + `domain` + `data` katmanlari.
- Feature bazli klasorleme:
  - `lib/features/recipe_assistant/presentation/`
  - `lib/features/recipe_assistant/domain/`
  - `lib/features/recipe_assistant/data/`
  - `lib/core/` (network, error, theme, ortak util)
- MVP'de tek ana feature: `recipe_assistant`.
- State yonetimi:
  - Ana akista tek bir `RecipeAssistantBloc` kullan (gereksiz parcalanmayi azaltir).
  - Dashboard ve backend ayri oldugu icin mobil tarafta ekstra global state'e gerek yok.

## 9. Flutter Entity Tasarimi (Domain)
- `IngredientEntity`
  - `name` (String)
  - `normalizedName` (String, opsiyonel)
- `RecipeIngredientEntity`
  - `name` (String)
  - `quantity` (double)
  - `unit` (String)
- `RecipeEntity`
  - `name` (String)
  - `ingredients` (List<RecipeIngredientEntity>)
  - `steps` (List<String>)
  - `prepTimeMinutes` (int)
  - `difficulty` (enum: easy, medium, hard)
- `RecipeRequestEntity`
  - `inputType` (enum: text, image, mixed)
  - `rawIngredientsText` (String?)
  - `recognizedIngredients` (List<IngredientEntity>)
  - `imagePathOrBase64` (String?, sadece mobil gecici kullanim)

## 10. Flutter BLoC Olay ve Durum Tasarimi
- `RecipeAssistantEvent`
  - `IngredientsTextChanged(text)`
  - `ImagePicked(path)`
  - `ImageCleared()`
  - `RecognizeIngredientsRequested()`
  - `IngredientRemoved(name)`
  - `ManualIngredientAdded(name)`
  - `GenerateRecipeRequested()`
  - `RetryPressed()`
  - `ResetFlow()`
- `RecipeAssistantState`
  - `status` (enum: initial, editing, loadingRecognition, loadingRecipe, success, failure)
  - `ingredientsText` (String)
  - `selectedImagePath` (String?)
  - `recognizedIngredients` (List<IngredientEntity>)
  - `recipe` (RecipeEntity?)
  - `errorMessage` (String?)
- Kural:
  - `GenerateRecipeRequested` tetiklenince ingredient listesi bossa validasyon hatasi don.
  - Her hata kullanici dostu mesajla `failure` state'ine insin.

## 11. Flutter Data Katmani (DTO + Repository)
- `RecipeAssistantRepository` (domain arayuzu)
  - `Future<List<IngredientEntity>> recognizeIngredientsFromImage(String imagePath)`
  - `Future<RecipeEntity> generateRecipe({required List<String> ingredients, String? rawText})`
- `RecipeAssistantRepositoryImpl` (data implementasyonu)
  - `RecipeApiService` uzerinden backend cagirilir.
- DTO modelleri:
  - `IngredientDto`
  - `RecipeIngredientDto`
  - `RecipeDto`
- Mapleme: DTO -> Entity donusumu data katmaninda tamamlanir.

## 12. Flutter Klasor Yapisi (MVP)
- `mobile/lib/main.dart`
- `mobile/lib/core/network/dio_client.dart`
- `mobile/lib/core/error/app_failure.dart`
- `mobile/lib/features/recipe_assistant/domain/entities/*.dart`
- `mobile/lib/features/recipe_assistant/domain/repositories/recipe_assistant_repository.dart`
- `mobile/lib/features/recipe_assistant/domain/usecases/recognize_ingredients_usecase.dart`
- `mobile/lib/features/recipe_assistant/domain/usecases/generate_recipe_usecase.dart`
- `mobile/lib/features/recipe_assistant/data/models/*.dart`
- `mobile/lib/features/recipe_assistant/data/datasources/recipe_api_service.dart`
- `mobile/lib/features/recipe_assistant/data/repositories/recipe_assistant_repository_impl.dart`
- `mobile/lib/features/recipe_assistant/presentation/bloc/recipe_assistant_bloc.dart`
- `mobile/lib/features/recipe_assistant/presentation/pages/ingredient_input_page.dart`
- `mobile/lib/features/recipe_assistant/presentation/pages/recipe_result_page.dart`
- `mobile/lib/features/recipe_assistant/presentation/widgets/*.dart`

## 13. Dashboard Metrikleri (Minimum 3 Grafik)
- En cok kullanilan malzemeler (bar chart).
- Gunluk tarif uretim sayisi (line chart).
- Basari/Basarisizlik orani (pie/donut chart).
- Ek (zaman kalirsa): saate gore uretim yogunlugu.

## 14. 7 Gunluk Adim Adim Is Plani
1. Gun 1 - Proje iskeleti
- Monorepo veya klasor yapisini olustur: `mobile/`, `backend/`, `dashboard/`.
- Firebase projesini hazirla, Firestore baglantisini dogrula.
- `.env.example` dosyalarini olustur.

2. Gun 2 - Flutter domain/presentation temel
- Entity, repository arayuzu, usecase siniflarini olustur.
- `RecipeAssistantBloc` event/state akisini yaz.
- Ingredient input ve result sayfalarinin temel UI'ini bagla.

3. Gun 3 - Backend temel
- Express server + middleware + central error handler.
- `POST /ingredients/recognize`, `POST /recipes/generate` endpointlerini iskeletle.
- Firestore'ya request/response loglama ekle.

4. Gun 4 - AI entegrasyonu
- Vision ile malzeme cikarma akisini bagla.
- Tarif uretim prompt'unu stabilize et, JSON parse/validate ekle.
- Hata senaryolari ve fallback mesajlari tamamla.

5. Gun 5 - Flutter entegrasyon + fotograf akisi
- API client + repository implementasyonu bagla.
- Kamera/galeri entegrasyonu.
- Fotograf -> malzeme algila -> tarif uret akisini tamamla.
- UX iyilestirmeleri (geri bildirimler, buton durumlari).

6. Gun 6 - Dashboard
- Firestore veya backend summary endpointinden veri cek.
- 3 grafik ekle ve filtreleme (son 7 gun/30 gun) gibi basit kontrol koy.
- Bos veri ve hata durumlarini ele al.

7. Gun 7 - Sonlandirma ve prova
- README: kurulum, calistirma, mimari kararlar, bilinen kisitlar.
- Kisa demo videosu/ekran goruntuleri (opsiyonel ama faydali).
- Canli oturum provasi: 2-3 ozellik degisikligini sure tutarak dene.

## 15. Flutter Test Plani (Minimum)
- `bloc_test` ile event -> state gecis testleri.
- `RecipeAssistantRepository` icin basit mock tabanli unit test.
- En az 1 widget test:
  - bos malzeme ile "Tarif Uret" => validasyon mesaji.
- Manuel smoke test:
  - text -> generate,
  - image -> recognize -> generate,
  - network fail -> kullanici dostu hata.

## 16. Test ve Dogrulama Kontrol Listesi
- Text input ile tarif uretiliyor mu?
- Image input ile malzeme tanima gercekten calisiyor mu?
- Tarifte zorunlu alanlar her zaman dolu mu?
- API hatalarinda uygulama "raw error" gostermiyor mu?
- Dashboard grafiklerinde veri dogru hesaplaniyor mu?
- README adimlariyla sifirdan kurulum yapilabiliyor mu?

## 17. README Icerik Taslagi
- Proje ozeti ve mimari diyagram (basit).
- Teknoloji secimleri ve nedenleri.
- Kurulum adimlari (backend, mobile, dashboard).
- Ortam degiskenleri (`.env.example`).
- AI prompt yaklasimi ve JSON schema.
- Bilinen kisitlar + "daha fazla zaman olsa" listesi.

## 18. Canli Teknik Oturum Hazirlik Plani
- Hazir mini degisikliklar:
  - Servings parametresi ekleme.
  - Yeni chart ekleme (saat bazli trend).
  - Basit bir bugfix senaryosu.
- Kod sahipligi:
  - Her kritik dosyada neyi neden yaptigini 1-2 cumleyle anlatabilecek netlik.
- AI kullanim seffafligi:
  - Nerede hizlandirdigini, neyi manuel duzelttigini not et.

## 19. Riskler ve Onlemler
- AI yanit formati bozulabilir -> strict schema + retry + fallback.
- Firebase konfig hatalari -> erken gunlerde health-check ve smoke test.
- Zaman riski -> once uc uca akisi bitir, sonra polish yap.
- Canli oturum stresi -> onceden time-box modifikasyon provasi.
