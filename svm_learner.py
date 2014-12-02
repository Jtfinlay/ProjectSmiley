from sklearn import svm

"""
A simple svm implementation using scikit-learn.

See http://scikit-learn.org/stable/install.html for
details on installing scikit-learn.
"""

def read_data(filename):
	"""
	Reads a naive csv vile of data and converts it into
	two arrays - one containing the feature vectors, and one
	containing the classifications.

	See http://scikit-learn.org/stable/modules/svm.html#multi-class-classification
	for an example of the input format.

	Parameters:
	  filename - The name of the file containing the data."
	"""
	data_file = open(filename, "r")
	data_lines = [line.split(',') for line in data_file.readlines()]
	data_file.close()

	features = [[float(f) for f in line[0:-1]] for line in data_lines]
	classes = [int(line[-1]) for line in data_lines]

	return features, classes

def train(features, classes):
	"""
	Returns an SVM classifier trained on the test data.

	See http://scikit-learn.org/stable/modules/generated/sklearn.svm.SVC.html#sklearn.svm.SVC

	Parameters:
	  features - An array of feature vectors.
	  classes - An array of classifications, one for each feature vector.
	"""
	classifier = svm.SVC(
		# We can mess around with the parameters here -
		# in particular, C, kernel, and gamma.
	)
	classifier.fit(features, classes)
	return classifier

