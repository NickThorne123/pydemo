

class Mat_data:
  """
  Class to hold data from one mat file
  """
  id_ = None
  age = None
  gender = None
  data_atts = None
  data_outcome = None
  data_output_test = None

  def __init__(self, id_, age = None, gender = None, data_atts =  None, data_outcome = None, data_output_test = None):  
    self.id_ = id_
    self.age = age
    self.gender = gender
    self.data_atts = data_atts
    self.data_outcome = data_outcome
    self.data_output_test = data_output_test
