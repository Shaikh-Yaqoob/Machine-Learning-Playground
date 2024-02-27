#!/usr/bin/env python
# coding: utf-8

# In[35]:


import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from sklearn.decomposition import PCA
import seaborn as sns
from sklearn.preprocessing import StandardScaler


# In[36]:


df = pd.read_csv("C:\\Users\\Asad Computrs\\Downloads\\customer.csv")
df.head()


# In[15]:


df['Age'].fillna(df['Age'].mean(), inplace=True)
df['Income'].fillna(df['Income'].mean(), inplace=True)
df['Education Level'].fillna(df['Education Level'].mode()[0], inplace=True)
df['Preferred Product Category'].fillna(df['Preferred Product Category'].mode()[0], inplace=True)
print(df)


# In[24]:


missing_values = df.isnull().sum()
print("missing values of distribution:")
print(missing_values)


# In[33]:


df['Age'].fillna(df['Age'].median(), inplace=True)
df['Income'].fillna(df['Income'].median(), inplace=True)

df['Education Level'].fillna(df['Education Level'].mode()[0], inplace=True)
df['Preferred Product Category'].fillna(df['Preferred Product Category'].mode()[0], inplace=True)

print("\nUpdated Dataset:")
print(df)


# In[25]:


numerical_stats = df[['Age', 'Income', 'Monthly Spending']].describe()
print("Statistics:")
print(numerical_stats)


# In[19]:


numerical_features = df[['Age', 'Income', 'Monthly Spending']]
numerical_features.fillna(numerical_features.median(), inplace=True)


# In[26]:


scale = StandardScaler()
numerical_features_standardized = scale.fit_transform(numerical_features)


# In[27]:


pca_1 = PCA(n_components=2)
principal_components = pca_1.fit_transform(numerical_features_standardized)


# In[28]:


df_red = pd.DataFrame(data=principal_components, columns=['Principal Component 1', 'Principal Component 2'])
df_red['Preferred Product Category'] = df['Preferred Product Category']


# In[34]:


plt.figure(figsize=(6, 4))
sns.scatterplot(x='Principal Component 1', y='Principal Component 2', hue='Preferred Product Category', data=reduced_df)
plt.title('reduced dimensinality of PCA with Preferred Product Category')
plt.show()


# In[ ]:




