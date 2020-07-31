shared_examples 'by month scope' do
  Given(:factory_name) { described_class.name.split('::').last.underscore }

  Given!(:april_entry) { create factory_name, posted_on: '2015.04.13' }
  Given!(:may_entry) { create factory_name, posted_on: '2015.05.13' }

  describe '#by_month' do
    Then { expect(described_class.by_month('2015.05.22').ids).to contain_exactly(may_entry.id) }
    And  { expect(described_class.by_month('2015.04.22').ids).to contain_exactly(april_entry.id) }
    And  { expect(described_class.by_month(nil).ids).to contain_exactly(may_entry.id, april_entry.id) }
  end

  describe '#archive_options' do
    Given { create factory_name, posted_on: may_entry.posted_on + 1.day }

    Then { expect(described_class.archive_options).to eq(['2015.05.01'.to_date, '2015.04.01'.to_date]) }
  end
end
