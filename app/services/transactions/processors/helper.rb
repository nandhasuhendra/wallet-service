module Transactions
  module Processors
    module Helper
      def source_wallet
        @source_wallet ||= WalletRepository.find_by_id_and_lock(@transaction.source_id)
      end

      def target_wallet
        @target_wallet ||= WalletRepository.find_by_id_and_lock(@transaction.target_id)
      end
    end
  end
end
