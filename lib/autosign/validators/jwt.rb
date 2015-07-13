module Autosign
  module Validators
    class JWT < Autosign::Validator
      def name
        "jwt_token"
      end

      private

      def perform_validation(token, certname, raw_csr)
        puts "attempting to validate JWT token"
        return false unless Autosign::Token.validate(certname, token, settings['secret'])
        puts "validated JWT token"
        @log.debug "validated JWT token, checking reusability"

        return true if is_reusable?(token)
        return true if add_to_journal(token)
        return false
      end

      def is_reusable?(token)
        Autosign::Token.from_token(token, settings['secret']).reusable
      end

      def add_to_journal(token)
        validated_token = Autosign::Token.from_token(token, settings['secret'])
        @log.debug 'add_to_journal settings: ' + settings.to_s
        journal = Autosign::Journal.new({'journalfile' => settings['journalfile']})
        token_expiration = Autosign::Token.token_validto(token, settings['secret'])

        # adding will return false if the token is already in the journal
        if journal.add(validated_token.uuid, token_expiration, validated_token.to_hash)
          @log.info "added token with UUID '#{validated_token.uuid}' to journal"
          return true
        else
          @log.warn "journal cannot validate one-time token; may already have been used"
          return false
        end
      end

      def default_settings
        {
          'journalfile' => '/var/autosign/autosign.journal'
        }
      end

      def get_override_settings
        # this is a hack to make testing easier
        if (ENV["AUTOSIGN_TESTMODE"] == "true" and
            !ENV["AUTOSIGN_TEST_SECRET"].nil? and
            !ENV["AUTOSIGN_TEST_JOURNALFILE"].nil? )
           {
             'secret'      => ENV["AUTOSIGN_TEST_SECRET"].to_s,
             'journalfile' => ENV["AUTOSIGN_TEST_JOURNALFILE"].to_s
           }
        else
          {}
        end
      end

    def validate_settings(settings)
      @log.debug "validating settings: " + settings.to_s
      if settings['secret'].is_a?(String)
        @log.info "validated settings successfully"
        return true
      else
        @log.error "no secret setting found"
        return false
      end
    end

    end
  end
end
