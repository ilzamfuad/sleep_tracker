# frozen_string_literal: true

module MetaBuilder
  class OTP < Base
    extend ::Dry::Initializer

    param :otp_meta

    def gen_meta
      otp_meta
    end
  end
end
