# Brain Tumor Detection from MRI Scans

A deep learning web app that classifies a brain MRI image as **Brain Tumor** or **Normal**. A convolutional neural network (CNN) built with Keras/TensorFlow does the classification, and a Flask front end lets you upload a scan and see the prediction with a confidence score.

> **Disclaimer:** This is an educational project. It is not a medical device and must not be used for diagnosis. Always consult a qualified medical professional.

---

## Features

- Upload an MRI image (any common image format) and get a prediction in seconds
- Shows the predicted class, the model's confidence percentage, and the processed image
- Result is color-coded (green for Normal, red for Brain Tumor)
- Simple landing page, login page and upload page built with Flask templates and Bootstrap
- Graceful error message if the uploaded file is not a valid image

## Model

| Item | Details |
|---|---|
| Framework | TensorFlow / Keras (`Sequential` CNN) |
| Input | 224 x 224 RGB image, pixel values scaled to 0-1 |
| Output | 2-class softmax (`Brain Tumor`, `Normal`) |
| Optimizer / loss | Adam / categorical cross-entropy |
| Training | 5 epochs, batch size 2 |
| Saved model | `save.h5` |

**Architecture**

```
Conv2D(32, 5x5, ReLU) -> MaxPool(3x3)
Conv2D(32, 3x3, ReLU) -> MaxPool(2x2)
Conv2D(64, 3x3, ReLU) -> MaxPool(2x2)
Flatten
Dense(512, ReLU) -> Dropout(0.25)
Dense(128, ReLU)
Dense(2, Softmax)
```

**Dataset:** [Brain MRI Images for Brain Tumor Detection](https://www.kaggle.com/navoneel/brain-mri-images-for-brain-tumor-detection-) on Kaggle. The notebook trains on 3,000 images and evaluates on a second 3,000-image `test` folder (1,500 per class in each).

## Results

Evaluation from `model/model.ipynb` after 5 epochs:

| Metric | Value |
|---|---|
| Accuracy | 0.995 |
| Precision | 0.993 |
| Recall | 0.995 |
| F1-score | 0.995 |

Confusion matrix (rows = true label, columns = predicted):

|  | Pred. Brain Tumor | Pred. Normal |
|---|---|---|
| **Brain Tumor** | 1490 | 10 |
| **Normal** | 5 | 1495 |

Final training accuracy was 0.977 (see `Accuracy.txt`).

## Project Structure

```
Brain Tumor Detection from MRI Scans/
├── app1.py              # Flask app: routes, preprocessing, prediction
├── save.h5              # Trained model loaded by the app
├── requirements.txt     # Setup notes and dependencies
├── Accuracy.txt         # Training accuracy note
├── model/
│   ├── model.ipynb      # Training and evaluation notebook
│   └── save.h5          # Copy of the trained model
├── templates/
│   ├── first.html       # Landing page
│   ├── login.html       # Login page
│   ├── index.html       # Image upload page
│   ├── result.html      # Prediction result page
│   └── chart.html       # Pie chart template (not linked to a route in app1.py)
├── static/              # CSS, JS, images and vendor libraries
└── upload/
    ├── Brain Tumor/     # Sample tumor MRI images for testing
    └── Normal/          # Sample normal MRI images for testing
```

## Getting Started

### Prerequisites

- Python 3.8 (64-bit)
- On Windows: [Microsoft Visual C++ Redistributable](https://support.microsoft.com/en-us/topic/the-latest-supported-visual-c-downloads-2647da03-1eea-4433-9aff-95f26a218cc0) (`vc_redist.x64.exe`), required by TensorFlow

### Installation

```bash
git clone https://github.com/krishanuchoudhary/Projects.git
cd "Projects/Brain Tumor Detection from MRI Scans"

python -m venv venv
# Windows: venv\Scripts\activate
# macOS/Linux: source venv/bin/activate

pip install numpy "Pillow<10" Keras tensorflow Flask Werkzeug gunicorn
```

> `app1.py` uses `Image.ANTIALIAS`, which was removed in Pillow 10, so install a Pillow version below 10 (or change it to `Image.LANCZOS`).

### Run the app

```bash
python app1.py
```

Open <http://127.0.0.1:5000> in your browser.

1. Go to **Login** and sign in with `admin` / `admin` (demo credentials, checked in the browser only)
2. On the upload page, choose an MRI image, for example one from the `upload/` folder
3. Submit to see the prediction and confidence score

### Retrain the model

1. Download the dataset from Kaggle and arrange it into `train/` and `test/` folders, each with one subfolder per class
2. Open `model/model.ipynb` and set `train_dir` and `test_dir` to your local paths
3. Run all cells, which end by saving the model with `model.save('save.h5')`
4. Replace `save.h5` in the project root with the new file

## How It Works

1. The uploaded image is converted to RGB and resized to 224 x 224
2. Pixel values are divided by 255 and passed to the CNN
3. The class with the highest softmax probability is returned along with its probability as the confidence score

## Limitations

- Trained for only 5 epochs on a small, single-source dataset, so it may not generalize to scans from other machines or hospitals
- Binary classification only: it does not identify tumor type, grade or location
- The login is a front-end demo with hardcoded credentials and offers no real security
- Not clinically validated

## Tech Stack

Python, TensorFlow/Keras, Flask, NumPy, Pillow, scikit-learn (evaluation), HTML/CSS/JavaScript, Bootstrap


