# Data-Models-R

Bu proje, İspanyolca Konuşma Verilerinin Analizi üzerine odaklanan bir veri analitiği ve makine öğrenimi projesidir. Veri seti, İspanyolca konuşma sırasında kaydedilen akustik özellikleri ve bazı demografik bilgileri içerir. Aşağıda, projede kullanılan yöntemler ve veri setinin detayları açıklanmıştır:

![spanish](https://github.com/user-attachments/assets/764613e0-21e4-4e4a-a94e-8f9e296219bc)

Veri Seti Parametreleri:

_ **cdur: Konuşma sırasında ölçülen sürenin bir bölümü.**
_ **vdur: Sesli harf süresi.**
_ **place: Artikülasyon yeri (ör. Velar, Dental).**
_ **stress: Vurgunun tipi (ör. Tonic, Unstressed).**
_ **prevowel ve posvowel: Önceki ve sonraki sesli harfler.**
_ **wordpos: Kelime içindeki pozisyon (ör. Initial, Medial).**
_ **wordfreq: Kelimenin frekansı (kullanım sıklığı).**
_ **speechrate: Konuşma hızı.**
_ **sex: Konuşmacının cinsiyeti (Kadın veya Erkek).**
_ **speaker: Konuşmacı kimliği (ör. s01).**

# Projenin Hedefleri

_ **Veriyi temizlemek ve analiz etmek.**
_ **Aykırı değerleri tespit etmek ve kaldırmak.**
_ **Eksik verileri doldurmak.**
_ **Akustik özellikler arasındaki ilişkileri incelemek.**
_ **Veriyi normalizasyon ve standardizasyon gibi yöntemlerle ön işleme tabi tutmak.**
_ **Özellik mühendisliği ile yeni değişkenler oluşturmak.**
_ **Kümeleme analizi ve zaman serisi modelleme gibi ileri düzey analitik yöntemler uygulamak.**


# Veri İncelemesi ve Eksik Veri Analizi

Veri setindeki eksik değerler ortalama ile dolduruldu. Eksik değerlerin görselleştirilmesi için Missingno kullanıldı.

# Aykırı Değerlerin Tespiti

cdur değişkeni için IQR (Interquartile Range) yöntemi kullanılarak aykırı değerler kaldırıldı.

# Veri Normalizasyonu ve Standardizasyon

cdur, vdur ve wordfreq değişkenleri Min-Max Skalası kullanılarak %0-100 aralığına normalleştirildi. vdur değişkeni, Standart Skalası ile yeniden ölçeklendirildi.


#  Kutu Grafikleri ve Yoğunluk Analizi
 
Histogram, kutu grafiği ve yoğunluk grafikleri ile cdur ve vdur değişkenlerinin dağılımı görselleştirildi. Korelasyon analizi için bir ısı haritası oluşturuldu.
_ **cdur_to_vdur_ratio: cdur ve vdur oranı hesaplandı.**
_ **log_wordfreq: wordfreq değişkeninin logaritması alındı.**

![vdur_o_s](https://github.com/user-attachments/assets/9d6be06e-7833-4056-a921-4d83042371f5)

![cdur](https://github.com/user-attachments/assets/a6f1e085-a445-4bb0-9e2a-0f6fc69e9c74)

![cdur-2](https://github.com/user-attachments/assets/7c1604e0-e7f7-4d4b-8bd2-7b4952b2dbb2)

# Korelasyon Analizi

Bu bölüm, seçilen sütunlar arasındaki ilişkinin yönünü ve gücünü analiz eder.

![korelasyon](https://github.com/user-attachments/assets/6cd0953a-2758-48df-bec2-5183130390e9)



# Kümeleme (Clustering)

K-Means algoritması, veri setindeki benzer özelliklere sahip veri noktalarını gruplamak (kümelemek) için kullanılan bir denetimsiz makine öğrenimi algoritmasıdır. 
Veri setindeki farklı grupları (ses süreleri ve frekans değerleri açısından benzerlik gösteren konuşma örnekleri) belirlemek için kullandık.
Özellikle ‘cdur’ (ses süresi), ‘vdur’ (sesli harf süresi) ve ‘wordfreq’ (kelime frekansı) gibi sayısal verilerdeki gizli yapıları anlamak ve görselleştirmek amacıyla kullanıldı. Kümeleme sonuçları bir dağılım grafiği ile görselleştirildi.

![k-means](https://github.com/user-attachments/assets/831ae8e8-5927-4b9d-81d8-53e497f99882)

# Zaman Serisi Analizi
    
cdur değişkeni üzerinde ARIMA ve Holt-Winters Exponential Smoothing modelleri ile tahminlemeler yapıldı.
Zaman serisi verisinin trend ve mevsimsellik gibi bileşenleri seasonal_decompose yöntemi ile analiz edildi.

![zaman cdur](https://github.com/user-attachments/assets/978fd6ff-cebc-4b1c-ac9e-d26ecc235eff)


# ARIMA (AutoRegressive Integrated Moving Average)

ARIMA modeli, zaman serisi verilerinin trendlerini ve desenlerini modellemek ve gelecekteki değerleri tahmin etmek için kullanılan bir yöntemdir. ‘cdur’ (ses süresi) zaman serisi verisinin geçmiş değerlerine dayanarak, gelecekteki olası değerleri tahmin etmek için kullanıldı. ARIMA, trend (artış/azalış) ve sezonsal (dönemsel) bileşenlerin analizi için uygundur. Verideki geçmiş bağımlılıkları dikkate alır.

![ARIMA ](https://github.com/user-attachments/assets/cf2ccf75-0a0a-453c-aec5-843b501e6f92)

# Holt-Winters Exponential Smoothing

Holt-Winters yöntemi, zaman serisi verilerindeki trend ve sezonsallık bileşenlerini modellemek için kullanılan bir yöntemdir. ‘cdur’ (ses süresi) verisinin hem trend hem de dönemsel (sezonsal) yapıya sahip olabileceğini varsaydık.

![exponential](https://github.com/user-attachments/assets/da095e13-714a-4a0c-85d6-0be791d6eed3)

# Sonuç ve Çıkarımlar

cdur, vdur ve wordfreq değişkenleri arasındaki korelasyon, konuşma süresi ve kelime sıklığına dair anlamlı bilgiler sundu.
Kümeleme analizi, veriyi üç gruba ayırarak akustik özelliklerdeki benzerlikleri gösterdi.
Zaman serisi analizi, konuşma süresindeki trendleri ve mevsimselliği ortaya çıkardı.


