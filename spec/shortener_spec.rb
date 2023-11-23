RSpec.describe Shortener do
  it 'has a version number' do
    expect(Shortener::VERSION).not_to be nil
  end

  it 'says equals for numbers' do
    # Example usage with recursive structure:
    n1 = 3
    n2 = 4
    n3 = 5

    expect(Shortener.deep_equal?(n1, n2)).to be false
    expect(Shortener.deep_equal?(n3, n3)).to be true
  end
  it 'says equals for hash' do
    # Example usage with recursive structure:
    hash1 = { a: { b: { c: 3 } } }
    hash2 = { a: { b: { c: 3 } } }
    hash3 = { a: { b: { c: 4 } } }

    expect(Shortener.deep_equal?(hash1, hash2)).to be true
    expect(Shortener.deep_equal?(hash2, hash3)).to be false
  end

  it 'Works for nested' do
    # Example with recursive structure
    family_tree1 = {
      name: 'John',
      age: 40,
      children: [
        { name: 'Alice', age: 15, children: [] },
        { name: 'Bob', age: 18, children: [
          { name: 'Charlie', age: 5, children: [] }
        ] }
      ]
    }

    family_tree2 = {
      name: 'John',
      age: 40,
      children: [
        { name: 'Alice', age: 15, children: [] },
        { name: 'Bob', age: 18, children: [
          { name: 'Charlie', age: 5, children: [] }
        ] }
      ]
    }
    expect(Shortener.deep_equal?(family_tree1, family_tree2)).to be true
  end
end
