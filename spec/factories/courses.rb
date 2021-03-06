FactoryGirl.define do
  factory :course do
    designator { ['CSCI', 'MATH', 'ENGL', 'PHYS'].sample }
    number { (100..999).to_a.sample }
    hidden { [true, false].sample }
  end
end
