# frozen_string_literal: true

class ResponseBuilder
  def initialize(object, template, status: 200, params: nil, additional_metas: [])
    @resource = object
    @template = template
    @status = status
    @params = params
    @additional_metas = additional_metas
  end

  def result
    build_response
  end

  private

  def build_response
    data = transform_resource_to_h

    meta_builders = @additional_metas
    meta_builders << ::MetaBuilder::Pagination.new(@params, @resource) if @resource.is_a? Array
    meta_builders << MetaBuilder::HttpStatus.new(@status)

    meta = MetaBuilder.build_meta(builders: meta_builders)

    { data: data, meta: meta }.to_json
  end

  def transform_resource_to_h
    return @template.new(@resource).hash_attributes unless @resource.is_a? Array

    res = []
    @resource.each do |element|
      res << @template.new(element).hash_attributes
    end

    res
  end
end
