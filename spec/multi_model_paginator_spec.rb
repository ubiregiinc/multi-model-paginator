RSpec.describe MultiModelPaginator do
  class Store
    class << self
      attr_accessor :list
    end
  end
  Store.list = []

  it "has a version number" do
    expect(MultiModelPaginator::VERSION).not_to be nil
  end
end
