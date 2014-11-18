from neural_net_learner          import read_data, train
from pybrain.supervised.trainers import BackpropTrainer
from pybrain.utilities           import percentError

"""
A simple test file that loads some data and runs
a neural net on it.  Should yield about 6-8% accuracy
on the test data.
"""

all_data = read_data("nn_test_data.csv")

# I don't think this function randomizes the data.
training_set, test_set = all_data.splitWithProportion(0.2)

# Calling _convertToOneOfMany before calling splitWithProportion
# leads to unexpected results, so we don't do it in read_data.
# Alternatively, read_data could split the data itself.
training_set._convertToOneOfMany()
test_set._convertToOneOfMany()

network = train(training_set)
print("{}% error".format(percentError(
	BackpropTrainer(network).testOnClassData(dataset=test_set),
	test_set['class']
)))

