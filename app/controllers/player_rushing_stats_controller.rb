class PlayerRushingStatsController < ApplicationController
  def index
    @player_rushing_stats = PlayerRushingStat

    if params[:player_name].present?
      @player_rushing_stats = @player_rushing_stats.where('player_name like ?', "%#{params[:player_name]}%")
    else
      @player_rushing_stats = @player_rushing_stats.all
    end

    if sort_column.present? && sort_order.present?
      @player_rushing_stats = @player_rushing_stats.order("#{sort_column} #{sort_order}")
    end

    respond_to do |format|
      format.html { @player_rushing_stats =  @player_rushing_stats.paginate(page: params[:page], per_page: 30) }
      format.csv { send_data PlayerRushingStat.to_csv(@player_rushing_stats),
                             filename: 'player_rushing_stats.csv'
      }
    end
  end

  private

  def sort_order
    %w[asc desc].include?(params[:sort_order]) ? params[:sort_order] : nil
  end

  def sort_column
    %w[total_rushing_yards total_rushing_touchdowns longest_rush].include?(params[:sort_column]) ? params[:sort_column] : nil
  end
end
