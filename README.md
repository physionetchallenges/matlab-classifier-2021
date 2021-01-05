# MATLAB example code for the PhysioNet/CinC Challenge 2021

## What's in this repository?

We implemented a linear regression model classifier that uses age, sex, and the root mean square of the ECG lead signals as features. This simple example illustrates how to format your MATLAB entry for the Challenge. However, it is **not** designed to score well (or, more accurately, designed not to do well), so you should not use it as a baseline for your model's performance.

The Matlab code contains two main sections: 
1. train: an example code to read the data and train a multiclass linear regression model.
2. test: an example code to classify and make prediction based on your training model. 

## How do I run these scripts?

You can run this classifier code by starting MATLAB and running

    train_model(training_data, model)
    test_model(model, test_data, test_outputs)

where `training_data` is a directory of training data files, `model` is a directory for saving your model, `test_data` is the directory of test data files (you can use the training data locally for debugging and cross-validation), and `test_outputs` is a directory for saving your model's outputs. The [PhysioNet/CinC Challenge 2021 webpage](https://physionetchallenges.org/2021/) provides a training database with data files and a description of the contents and structure of these files.

After training your model and obtaining test outputs using the above two command lines, you can evaluate the scores of your model using the [PhysioNet/CinC Challenge 2021 evaluation code](https://github.com/physionetchallenges/evaluation-2021) by running

     evaluate_model(labels, outputs, scores.csv, class_scores.csv)

where `labels` is a directory containing files with one or more labels for each ECG recording, such as the training data files on the PhysioNet webpage; `outputs` is a directory containing files with outputs produced by your algorithm for those recordings; `scores.csv` (optional) is a collection of scores for your algorithm; and `class_scores.csv` (optional) is a collection of per-class scores for your algorithm.

## Which scripts I can edit?

We will run the `train_model.m` and `test_model.m` scripts to run your training code and testing code, so check these scripts and the functions that they call.
Our example code uses four main scripts to train and test your model for the 2021 Challenge: 

Please edit the following scripts to add your training and testing code:
* `team_training_code.m` is a script with functions for training your model and running your trained model.
* `team_testing_code.m` is a script with functions for loading your model, extrating features from your test data and predict outputs using the classifier.

Please do **not** edit the following scripts. We will use the unedited versions of these scripts.
* `train_model.m` is a script for calling your training code on the training data.
* `test_model.m` is a script for calling your trained model on the test data.

These four scripts must remain in the root path of your repository, but you can put other scripts and other files in subfolders.

## How do I train, save, load, and run my model?

To train and save your model, please edit the `get_features` function in the `team_code.m` script. `get_features` is a script with functions for extracting the available leads of the data (`get_leads`), preprocessing the signals and extracting features from ECG leads. 

To load and run your trained model, please edit the `team_testing_code`, which takes an ECG recording as an input and returns the class labels and probabilities for the ECG recording as outputs. Please do not edit the input or output arguments of the functions for loading or running your models.

## How to extract reduced leads sets from training data?

In the [Python example code](https://github.com/physionetchallenges/python-classifier-2021), we included a script, `extract_leads_wfdb.py`, for extracting reduced-lead sets from the training data. You can use our python script to produce reduce leads data and use them to test your code. 

## How do I learn more?

Please see the [PhysioNet/CinC Challenge 2021 webpage](https://physionetchallenges.org/2021/) for more details. Please post questions and concerns on the [Challenge discussion forum](https://groups.google.com/forum/#!forum/physionet-challenges).

## Useful links

- [The PhysioNet/CinC Challenge 2021 webpage](https://physionetchallenges.org/2021/)

- [Python example code for the PhysioNet/CinC Challenge 2021](https://github.com/physionetchallenges/python-classifier-2021)

- [Evaluation code for the PhysioNet/CinC Challenge 2021](https://github.com/physionetchallenges/evaluation-2021)

- [Frequently Asked Questions (FAQ)](https://physionetchallenges.org/faq/)
