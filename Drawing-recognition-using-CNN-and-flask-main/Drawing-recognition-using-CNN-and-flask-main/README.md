
 
<div align="center">
  
[1]: https://github.com/Pradnya1208
[2]: https://www.linkedin.com/in/pradnya-patil-b049161ba/
[3]: https://public.tableau.com/app/profile/pradnya.patil3254#!/
[4]: https://twitter.com/Pradnya1208


[![github](https://raw.githubusercontent.com/Pradnya1208/Telecom-Customer-Churn-prediction/c292abd3f9cc647a7edc0061193f1523e9c05e1f/icons/git.svg)][1]
[![linkedin](https://raw.githubusercontent.com/Pradnya1208/Telecom-Customer-Churn-prediction/9f5c4a255972275ced549ea6e34ef35019166944/icons/iconmonstr-linkedin-5.svg)][2]
[![tableau](https://raw.githubusercontent.com/Pradnya1208/Telecom-Customer-Churn-prediction/e257c5d6cf02f13072429935b0828525c601414f/icons/icons8-tableau-software%20(1).svg)][3]
[![twitter](https://raw.githubusercontent.com/Pradnya1208/Telecom-Customer-Churn-prediction/c9f9c5dc4e24eff0143b3056708d24650cbccdde/icons/iconmonstr-twitter-5.svg)][4]

</div>

# <div align="center"> Drawing recognition using CNN and flask</div>
<div align="center">
<img src  ="https://github.com/Pradnya1208/Drawing-recognition-using-CNN-and-flask/blob/main/output/intro.jpeg?raw=true" width="100%">
</div>
 
 

## Objectives:
In this project our goal is to Develop an Interactive Drawing Recognition App based on CNN — Deploy it with Flask.
For the purpose of training and simplicity we are developing ths app for smaller dataset.
## Dataset:
[Quick Draw Dataset](https://console.cloud.google.com/storage/browser/quickdraw_dataset/full/numpy_bitmap;tab=objects?pli=1&prefix=&forceOnObjectsSortingFiltering=false)

We are using the data from the ‘Quick, draw!’ game where users need to draw as quickly as possible an arbitrary object.
For the simplicity we are using the drawings of eye, arm, face, finger, hand, leg, mouth, nose, and ear.

Here is a sample of the data :

![faces](https://github.com/Pradnya1208/Drawing-recognition-using-CNN-and-flask/blob/main/output/faces.PNG?raw=true)<br>
Images from this dataset were already preprocessed to a uniform 28*28 pixel image size. We are using only 10000 samples for each category.<br>
We then normalize the values between 0 and 1 (X/255) as pixels of a grayscale image lie between 0 and 255.

## Implementation:

**Libraries:** `Keras` `sklearn` `Matplotlib` `pandas` `seaborn` `NumPy` `flask` `pickle` `tensorflow`

### Model Architecture:

```
def cnn_model():
    # create model
    model = Sequential()
    model.add(Conv2D(30, (3, 3), input_shape=(28, 28,1), activation='relu'))
    model.add(MaxPooling2D(pool_size=(2, 2)))
    model.add(Conv2D(15, (3, 3), activation='relu'))
    model.add(MaxPooling2D(pool_size=(2, 2)))
    model.add(Dropout(0.2))
    model.add(Flatten())
    model.add(Dense(128, activation='relu'))
    model.add(Dense(50, activation='relu'))
    model.add(Dense(num_classes, activation='softmax'))
    # Compile model
    model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])
    return model
```

- **Convolutional Layer** : 30 filters, (3 * 3) kernel size
- **Max Pooling Layer** : (2 * 2) pool size
- **Convolutional Layer** : 15 filters, (3 * 3) kernel size
- **Max Pooling Layer** : (2 * 2) pool size
- **DropOut Layer** : Dropping 20% of neurons.
- **Flatten Layer**
- **Dense/Fully Connected Layer** : 128 Neurons, Relu activation function
- **Dense/Fully Connected Layer** : 50 Neurons, Softmax activation function


```
np.random.seed(0)
# build the model
model_cnn = cnn_model()
# Fit the model
model_cnn.fit(X_train_cnn, y_train_cnn, validation_data=(X_test_cnn, y_test_cnn), epochs=19, batch_size=200)
# Final evaluation of the model
scores = model_cnn.evaluate(X_test_cnn, y_test_cnn, verbose=0)
print('Final CNN accuracy: ', scores[1])
```
```
Final CNN accuracy:  0.9014999866485596
```

### Confusion Matrix:
![cm](https://github.com/Pradnya1208/Drawing-recognition-using-CNN-and-flask/blob/main/output/confusion%20matrix.PNG?raw=true)
<br>As we can see, most of the drawings were well classified. However, some classes seem to be harder to differentiate than others.

### Misclassified Images:
![Misclassified](https://github.com/Pradnya1208/Drawing-recognition-using-CNN-and-flask/blob/main/output/misclassified.PNG?raw=true)


## Saving the Model
Now that our model is ready, we can embed it into a Flask Web-App. To do so, it is more convenient to save (serialize) our model using pickle.

While saving the model, I encountered with the error `Model not picklable`.<br>
following is the hotfix I used for this:
[Reference](https://github.com/tensorflow/tensorflow/issues/34697)
```
import pickle

from tensorflow.keras.models import Sequential, Model
from tensorflow.keras.layers import Dense
from tensorflow.python.keras.layers import deserialize, serialize
from tensorflow.python.keras.saving import saving_utils


def unpack(model, training_config, weights):
    restored_model = deserialize(model)
    if training_config is not None:
        restored_model.compile(
            **saving_utils.compile_args_from_training_config(
                training_config
            )
        )
    restored_model.set_weights(weights)
    return restored_model

# Hotfix function
def make_keras_picklable():

    def __reduce__(self):
        model_metadata = saving_utils.model_metadata(self)
        training_config = model_metadata.get("training_config", None)
        model = serialize(self)
        weights = self.get_weights()
        return (unpack, (model, training_config, weights))

    cls = Model
    cls.__reduce__ = __reduce__

# Run the function
make_keras_picklable()
```
### Saving the model:
```
import pickle
with open('model_cnn.pkl', 'wb') as file:
      pickle.dump(model_cnn, file)
```

## Developing the Drawing Web-App with Flask:
### Flask:
Flask is a web micro-framework written in Python. It allows you to design a solid and professional web application.

#### app.py:
Is the main code that will run our Flask application. It will contain the different routes for our application, respond to HTTP requests and decide what to display in the templates. In our case, it will also call our `CNN classifier`, operate pre-processing steps for our input data and make prediction.
#### Template Folder:
A template is an HTML file which can receive Python objects and is linked to the Flask application. Hence, our html pages will be stored in this folder.
#### Static folder: 
Style sheets, scripts, images and other elements that will never be generated dynamically must be stored in this folder. We will place our Javascript and CSS files in it.

### Requiremets:
This project will require:
- **Two static files** : draw.js and styles_draw.css
- **Two template files** : draw.html and results.html.
- **Our main file** : IPYNB notbook
- **Our model** : model_cnn.pkl saved earlier.

## Main points of this code :

1) **Initializing the app and specifying the template folder**:
We can do that using this line of code :
```
app = flask.Flask(__name__, template_folder =’templates’)
```
2) **Define the routes (only two for our app)** :
```
@app.route(‘/’) 
```
This is our default path — It will return the default draw.html template.
```
@app.route(‘/predict’)
``` 
This is called when clicking on the ‘predict’ button. Returns the results.html template after processing the user input.

3) **The predict function** will be triggered by a POST action from the form.
<br>It will then proceed as follows :
- Access the base64 encoded drawing input with request.form['url'] , where ‘url’ is the name of the hidden input field in the form which contains the encoded image.
- Decode the image and set it into an array.
- Resize and reshape the image to get a 28 * 28 input for our model. We care about keeping its ratio.
- Perform the prediction using our CNN classifier.
- As model.predict() returns a probablity for each class in a single array, we must find the array’s highest probability and get the corresponding class using the pre-defined dictionary.
- Finally return the results.html template and pass the previously made prediction as parameter :

```
return render_template('results.html', prediction= final_pred)
```

## Run the app:
```
if __name__ == '__main__':
    app.run(debug=False)
```
![result](https://github.com/Pradnya1208/Drawing-recognition-using-CNN-and-flask/blob/main/output/output_gif.gif?raw=true)
## Lessons Learned

`Convolutional Neural Network`
`Image Processing`
`Model Saving`
`App development using Flask`

## References:
[Drawing recognition app](https://towardsdatascience.com/develop-an-interactive-drawing-recognition-app-based-on-cnn-deploy-it-with-flask-95a805de10c0)
## Feedback

If you have any feedback, please reach out at pradnyapatil671@gmail.com


## 🚀 About Me
#### Hi, I'm Pradnya! 👋
I am an AI Enthusiast and  Data science & ML practitioner



[1]: https://github.com/Pradnya1208
[2]: https://www.linkedin.com/in/pradnya-patil-b049161ba/
[3]: https://public.tableau.com/app/profile/pradnya.patil3254#!/
[4]: https://twitter.com/Pradnya1208


[![github](https://raw.githubusercontent.com/Pradnya1208/Telecom-Customer-Churn-prediction/c292abd3f9cc647a7edc0061193f1523e9c05e1f/icons/git.svg)][1]
[![linkedin](https://raw.githubusercontent.com/Pradnya1208/Telecom-Customer-Churn-prediction/9f5c4a255972275ced549ea6e34ef35019166944/icons/iconmonstr-linkedin-5.svg)][2]
[![tableau](https://raw.githubusercontent.com/Pradnya1208/Telecom-Customer-Churn-prediction/e257c5d6cf02f13072429935b0828525c601414f/icons/icons8-tableau-software%20(1).svg)][3]
[![twitter](https://raw.githubusercontent.com/Pradnya1208/Telecom-Customer-Churn-prediction/c9f9c5dc4e24eff0143b3056708d24650cbccdde/icons/iconmonstr-twitter-5.svg)][4]

