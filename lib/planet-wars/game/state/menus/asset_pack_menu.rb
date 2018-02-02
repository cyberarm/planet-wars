class AssetPackMenu < GameUI
  def create
    set_title "#{GameInfo::NAME}//Settings//Asset Packs"
    @asset_packs = AssetManager.asset_packs
    @asset_packs.each do |asset_pack|
      next unless Dir.exists?(asset_pack)
      button "#{File.basename(asset_pack)}" do
        ConfigManager.update("asset_pack", File.basename(asset_pack))
        AssetManager::IMAGE_CACHE.clear
        AssetManager::SONG_CACHE.clear
        AssetManager::SAMPLE_CACHE.clear
        AssetManager.preload_assets
        AssetManager.update_theme_data
        selected[:tooltip] = "Asset Pack Changed."
      end
    end

    button "Back" do
      push_game_state(SettingsMenu)
    end
  end
end
