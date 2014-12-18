class AssetPackMenu < GameUI
  def initialize options={}
    options[:title] = "#{GameInfo::NAME}//Settings//Asset Packs"
    super
    @asset_packs = AssetManager.asset_packs
    @asset_packs.each do |asset_pack|
      next unless Dir.exists?(asset_pack)
      button "#{File.basename(asset_pack)}" do
        ConfigManager.update("asset_pack", File.basename(asset_pack))
        Gosu::Image.clear
        Gosu::Song.clear
        Gosu::Sample.clear
        AssetManager.preload_assets
        selected[:tooltip] = "assetpack changed."
      end
    end

    button "Back" do
      push_game_state(SettingsMenu)
    end
  end
end
