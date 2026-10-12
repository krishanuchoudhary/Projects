import os
from flask import Flask, request, render_template
from PIL import Image, ImageOps
import numpy as np
from tensorflow.keras.models import load_model
import base64
import urllib
from io import BytesIO  # ✅ Required for image encoding

app = Flask(__name__)

# ✅ Load the trained model
model = load_model('save.h5')  # Ensure this file exists in your working directory

@app.route("/")
@app.route("/first")
def first():
    return render_template('first.html')

@app.route("/login")
def login():
    return render_template('login.html')

@app.route("/index", methods=['GET'])
def index():
    return render_template('index.html')

@app.route("/upload", methods=['POST'])
def upload_file():
    print("Image Upload Requested")  # Debug log

    try:
        img = Image.open(request.files['imagefile'].stream).convert('RGB')
        img = ImageOps.fit(img, (224, 224), Image.ANTIALIAS)
    except Exception as e:
        print(f"Error in image processing: {e}")
        error_msg = "Please upload a valid image file!"
        return render_template('result.html', error_msg=error_msg)

    # Prediction
    out_pred, out_prob = predict({'input': img})
    out_prob = out_prob * 100  # Percentage
    print(f"Prediction: {out_pred}, Probability: {out_prob:.2f}%")  # Debug

    danger = "danger"
    if "Normal" in out_pred:
        danger = "success"

    # Prepare image to display in result.html
    img_io = BytesIO()
    img.save(img_io, 'PNG')
    png_output = base64.b64encode(img_io.getvalue()).decode('utf-8')
    processed_file = urllib.parse.quote(png_output)

    return render_template('result.html',
                           out_pred=out_pred,
                           out_prob=f"{out_prob:.2f}%",
                           processed_file=processed_file,
                           danger=danger)

def predict(args):
    img = np.array(args['input']) / 255.0
    img = np.expand_dims(img, axis=0)

    pred = model.predict(img)

    if np.argmax(pred, axis=1)[0] == 0:
        out_pred = ("Result: Brain Tumor  \n"
                    "Symptoms: unexplained weight loss, double vision, "
                    "hearing loss, weakness on one side of the body.")
    elif np.argmax(pred, axis=1)[0] == 1:
        out_pred = "Result: Normal"
    else:
        out_pred = "Unknown Result"

    return out_pred, float(np.max(pred))

if __name__ == '__main__':
    app.run(debug=True)
