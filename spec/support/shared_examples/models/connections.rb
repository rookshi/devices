shared_examples_for 'a resource connection' do |connection, factory|

  context 'when creates resource connection' do

    context 'with valid connections' do

      let(:resource)      { FactoryGirl.create factory, "with_no_#{connection}", connection => connection_params }
      let(:connection_id) { resource.send(connection).first.send("#{connection.singularize}_id") }

      it 'creates one connection' do
        resource.send(connection).should have(1).items
      end

      it 'creates connection id' do
        connection_id.should == connection_resource.id
      end
    end

    context 'with pre-existing connections' do

      let(:resource) { FactoryGirl.create factory }
      let!(:old) { resource.send(connection).first }

      before { resource.update_attributes connection => connection_params }
      let!(:new) { resource.send(connection).first }

      it 'replaces previous connections' do
        new.id.should_not == old.id
      end
    end

    context 'with empty connections' do

      let(:resource) { FactoryGirl.create factory, connection => [] }

      it 'removes previous connections' do
        resource.send(connection).should have(0).items
      end
    end

    context 'with no connections' do

      let(:resource) { FactoryGirl.create factory }
      before         { resource.update_attributes {} }

      it 'does not change anything' do
        resource.send(connection).should have(2).items
      end
    end
  end
end
