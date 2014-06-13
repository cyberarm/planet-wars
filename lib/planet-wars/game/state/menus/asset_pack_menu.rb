class AssetPackMenu < GameUI
  def initialize options={}
    options[:title] = "#{GameInfo::NAME}//Settings//Asset Packs"
    super
    @asset_packs = AssetManager.asset_packs
    @asset_packs.each do |asset_pack|
      next unless Dir.exists?(asset_pack)
      button "#{File.basename(asset_pack)}" do
        ConfigManager.update("asset_pack", File.basename(asset_pack))
        selected[:tooltip] = "assetpack changed."
      end
    end

    button "Back" do
      push_game_state(previous_game_state)
    end
  end
end