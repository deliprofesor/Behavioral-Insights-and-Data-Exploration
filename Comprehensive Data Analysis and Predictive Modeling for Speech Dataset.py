import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.preprocessing import MinMaxScaler, StandardScaler
from sklearn.cluster import KMeans
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.ensemble import RandomForestClassifier, IsolationForest 
from sklearn.metrics import confusion_matrix, silhouette_score
import statsmodels.api as sm
import missingno as msno
from sklearn.linear_model import LassoCV
from statsmodels.tsa.arima.model import ARIMA
from statsmodels.tsa.holtwinters import ExponentialSmoothing



# 1. Veri Yükleme
data_path = 'PTK_Spanish_Speech_data.csv'
df = pd.read_csv(data_path)

# Veri inceleme
print(df.head())
print(df.describe())
print("Eksik değerler:")
print(df.isnull().sum())

msno.matrix(df)
plt.show()

# IQR ile aykırı değer analizi
Q1 = df['cdur'].quantile(0.25)
Q3 = df['cdur'].quantile(0.75)
IQR = Q3 - Q1
lower_bound = Q1 - 1.5 * IQR
upper_bound = Q3 + 1.5 * IQR
df_filtered = df[(df['cdur'] >= lower_bound) & (df['cdur'] <= upper_bound)]

# Eksik değer doldurma
if 'cdur' in df.columns:
    df['cdur'] = df['cdur'].fillna(df['cdur'].mean())

# 2. Min-Max Normalizasyon Fonksiyonu
scaler = MinMaxScaler()

# 3. Normalizasyon İşlemi
normalize_columns = ['cdur', 'vdur', 'wordfreq']
df[normalize_columns] = scaler.fit_transform(df[normalize_columns]) * 100

# 4. Standardizasyon
if 'vdur' in df.columns:
    scaler_standard = StandardScaler()
    df['vdur_scaled'] = scaler_standard.fit_transform(df[['vdur']])
    print(f"Standardize edilmiş 'vdur' ortalama: {df['vdur_scaled'].mean()}")
    print(f"Standardize edilmiş 'vdur' standart sapma: {df['vdur_scaled'].std()}")
else:
    print("'vdur' sütunu veri setinde bulunamadı.")

# 5. Grafiklerle Veriyi Görselleştirme
plt.figure(figsize=(12, 6))

# Orijinal 'vdur' histogramı
plt.subplot(3, 1, 1)
plt.hist(df['vdur'], bins=20, color='skyblue', edgecolor='black')
plt.title("Orijinal 'vdur'")

# Standardize edilmiş 'vdur' histogramı
plt.subplot(3, 1, 2)
plt.hist(df['vdur_scaled'], bins=20, color='green', edgecolor='black')
plt.title("Standardize Edilmiş 'vdur'")

plt.tight_layout()
plt.show()

# 6. Veriyi Kaydetme
df.to_csv('Normalized_and_Scaled_Data.csv', index=False)


# 7. Kutu Grafikleri ve Yoğunluk Analizi
plt.figure(figsize=(12, 6))

# 'cdur' sütunu için kutu grafiği
plt.subplot(1, 2, 1)
sns.boxplot(x=df['cdur'], color='lightblue')
plt.title("cdur için Kutu Grafiği")

# 'cdur' yoğunluk grafiği
plt.subplot(1, 2, 2)
sns.kdeplot(df['cdur'], color='darkgreen', linewidth=2)
plt.title("cdur için Yoğunluk Grafiği")

plt.tight_layout()
plt.show()

# 8. Korelasyon Analizi
cor_matrix = df[['cdur', 'vdur', 'wordfreq']].corr()
plt.figure(figsize=(8, 6))
sns.heatmap(cor_matrix, annot=True, cmap='coolwarm', fmt='.2f', linewidths=0.5)
plt.title("Korelasyon Matrisi")
plt.show()

# 9. Outlier Temizleme
df = df[df['cdur'] < df['cdur'].quantile(0.95)]

# 10. Yeni Özellikler Oluşturma
df['cdur_to_vdur_ratio'] = df['cdur'] / (df['vdur'] + 1)
df['log_wordfreq'] = np.log1p(df['wordfreq'])

# 11. K-Means Kümeleme ve Görselleştirme
df_numeric = df[['cdur', 'vdur', 'wordfreq']]
kmeans = KMeans(n_clusters=3, random_state=42)
df['cluster'] = kmeans.fit_predict(df_numeric)

plt.figure(figsize=(8, 6))
sns.scatterplot(x='cdur', y='vdur', hue='cluster', data=df, palette='Set1', s=100)
plt.title("K-Means Kümeleme Sonuçları")
plt.show()

# 12. Eğitim ve Test Verisi Ayrımı
if 'hedef_sutun' in df.columns:
    X = df.drop('hedef_sutun', axis=1)
    y = df['hedef_sutun']
    
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    
    model = RandomForestClassifier(random_state=42)
    model.fit(X_train, y_train)
    
    predictions = model.predict(X_test)
    cm = confusion_matrix(y_test, predictions)
    print("Confusion Matrix:")
    print(cm)
else:
    print("'hedef_sutun' sütunu bulunamadı, model oluşturulamadı.")

# 13. Zaman Serisi Analizi ve Görselleştirme
if 'cdur' in df.columns:
    ts_data = df['cdur']
    plt.figure(figsize=(10, 6))
    plt.plot(ts_data, color='darkblue', linewidth=2)
    plt.title("Zaman Serisi: 'cdur'")
    plt.show()

    # Zaman serisi parçalama
    ts_data = ts_data.dropna()
    ts_data = sm.tsa.seasonal_decompose(ts_data, model='additive', period=12)
    ts_data.plot()
    plt.show()


# Lasso ile özellik seçimi
X = df.drop('target_column', axis=1)
y = df['target_column']
lasso = LassoCV()
lasso.fit(X, y)
feature_importance = pd.Series(lasso.coef_, index=X.columns).sort_values(ascending=False)
print(feature_importance)

# ARIMA Modeli
model = ARIMA(ts_data, order=(5, 1, 0))  # ARIMA(p,d,q) parametrelerini optimize edebilirsiniz
model_fit = model.fit()
forecast = model_fit.forecast(steps=12)  # 12 adım ileriye tahmin
plt.plot(forecast)
plt.title('ARIMA Forecast')
plt.show()

# RandomForest parametre tuning
param_grid = {
    'n_estimators': [100, 200, 300],
    'max_depth': [None, 10, 20],
    'min_samples_split': [2, 5, 10]
}

grid_search = GridSearchCV(estimator=RandomForestClassifier(), param_grid=param_grid, cv=5)
grid_search.fit(X_train, y_train)
print("Best parameters:", grid_search.best_params_)

silhouette_avg = silhouette_score(df_numeric, kmeans.labels_)
print("Silhouette Score: ", silhouette_avg)

sns.pairplot(df[['cdur', 'vdur', 'wordfreq', 'target_column']], hue='target_column')
plt.show()

# RandomForest feature importance visualization
feature_importance = model.feature_importances_
plt.barh(X.columns, feature_importance)
plt.xlabel('Feature Importance')
plt.show()

model = IsolationForest(contamination=0.1)
anomalies = model.fit_predict(df_numeric)
df['Anomaly'] = anomalies
sns.scatterplot(x='cdur', y='vdur', hue='Anomaly', data=df, palette='coolwarm')
plt.title("Anomaly Detection")
plt.show()


# Holt-Winters Exponential Smoothing
model = ExponentialSmoothing(ts_data, trend='add', seasonal='add', seasonal_periods=12)
model_fit = model.fit()
forecast = model_fit.forecast(steps=12)
plt.plot(forecast)
plt.title('Exponential Smoothing Forecast')
plt.show()

df[['cdur', 'vdur', 'wordfreq']].hist(bins=30, figsize=(10, 6))
plt.show()

df['rolling_mean'] = df['cdur'].rolling(window=10).mean()
df['rolling_std'] = df['cdur'].rolling(window=10).std()
df[['cdur', 'rolling_mean', 'rolling_std']].plot(figsize=(10, 6))
plt.show()
