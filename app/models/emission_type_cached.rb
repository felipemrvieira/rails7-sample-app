class EmissionTypeCached
  def self.all
    return @@all unless @@all.pluck(:emission_type_id).all? { |e| e.blank? }

    @@all.each do |type|
      type[:emission_type_id] = EmissionType.find_by_name(type.name)&.id
    end
  end

  def self.default
    all.find { |vt| vt.slug == Setting.default_emission_emission_type_slug }
  end

  def self.find_by_slug(slug)
    all.find { |vt| vt.slug == slug }
  end

  def self.find_by_name(name)
    all.find { |vt| vt.name == name }
  end

  def self.find_by_id(id)
    all.find { |vt| vt.emission_type_id == id }
  end

  def self.emission_type_groupings(emission_type_name)
    case emission_type_name
    # when I18n.t('emission_type.net_emission')
    when 'Emissões Líquidas'
      [
        find_by_slug('emissao'),
        find_by_slug('remocao')
      ]
    else
      [ find_by_name(emission_type_name) ]
    end
  end

  def self.set_conditions(emission_type_name, conditions)
    case emission_type_name
    when I18n.t('emission_type.net_emission')
      conditions.merge(conditions_for_net_emission)
    when I18n.t('emission_type.net_emission_without_remotion')
      conditions.merge(conditions_for_net_emission_without_remotion)
    else
      conditions.merge(emission_type_id: find_by_name(emission_type_name)&.emission_type_id)
    end
  end

  def self.conditions_for_net_emission
    emission_types_for_net_emission
  end

  def self.conditions_for_net_emission_without_remotion
    emission_types_for_net_emission.merge(
      {
        level_2: levels_for_net_emission_without_remotion
      }
    )
  end

  def self.emission_types_for_net_emission
    @allowed_ids ||= [
      EmissionType.find_by_name(I18n.t('emission_type.emission')),
      EmissionType.find_by_name(I18n.t('emission_type.remotion'))
    ]

    {
      emission_type_id: @allowed_ids
    }
  end

  def self.levels_for_net_emission_without_remotion
    Level.filtered_by_slug('remocoes-de-areas-protegidas')
  end

  private

  @@struct ||= Struct.new(:name, :slug, :emission_type_id)

  @@all = [
    @@struct.new(I18n.t('emission_type.emission'), 'emissao'),
    @@struct.new(I18n.t('emission_type.remotion'), 'remocao'),
    @@struct.new(I18n.t('emission_type.net_emission'), 'emissoes-liquidas'),
    # @@struct.new(I18n.t('emission_type.net_emission_without_remotion'), 'emissoes-liquidas-sem-remocoes'),
    @@struct.new(I18n.t('emission_type.emission_nci'), 'emission_nci'),
    @@struct.new(I18n.t('emission_type.remotion_nci'), 'remotion_nci'),
    # @@struct.new(I18n.t('emission_type.emission_new_beta'), 'emissao_new_beta'),
    # @@struct.new(I18n.t('emission_type.remotion_new_beta'), 'remocao_new_beta'),
    @@struct.new(I18n.t('emission_type.bunker'), 'bunker'),
  ].freeze
end
