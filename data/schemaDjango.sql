BEGIN;
CREATE TABLE `coordinate_systems` (
    `id` integer NOT NULL PRIMARY KEY,
    `short_name` varchar(150) NOT NULL,
    `long_name` varchar(765) NOT NULL,
    `notes` longtext NOT NULL,
    `reference` varchar(765) NOT NULL,
    `created_at` datetime,
    `updated_at` datetime
)
;
CREATE TABLE `locations` (
    `id` integer NOT NULL PRIMARY KEY,
    `name` varchar(765) NOT NULL,
    `lat` double precision,
    `long` double precision,
    `notes` longtext NOT NULL,
    `coordinate_system_id` integer,
    `created_at` datetime,
    `updated_at` datetime
)
;
ALTER TABLE `locations` ADD CONSTRAINT `coordinate_system_id_refs_id_ada29427` FOREIGN KEY (`coordinate_system_id`) REFERENCES `coordinate_systems` (`id`);
CREATE TABLE `regions` (
    `id` integer NOT NULL PRIMARY KEY,
    `name` varchar(765) NOT NULL,
    `notes` longtext NOT NULL,
    `created_at` datetime,
    `updated_at` datetime
)
;
CREATE TABLE `in_regions` (
    `id` integer NOT NULL PRIMARY KEY,
    `location_id` integer,
    `region_id` integer,
    `notes` longtext NOT NULL,
    `created_at` datetime,
    `updated_at` datetime
)
;
ALTER TABLE `in_regions` ADD CONSTRAINT `region_id_refs_id_6d008f7e` FOREIGN KEY (`region_id`) REFERENCES `regions` (`id`);
ALTER TABLE `in_regions` ADD CONSTRAINT `location_id_refs_id_71a638ab` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`);
CREATE TABLE `continents` (
    `id` integer NOT NULL PRIMARY KEY,
    `name` varchar(765) NOT NULL,
    `created_at` datetime,
    `updated_at` datetime
)
;
CREATE TABLE `states` (
    `id` integer NOT NULL PRIMARY KEY,
    `name` varchar(765) NOT NULL,
    `continent_id` integer NOT NULL,
    `notes` longtext NOT NULL,
    `created_at` datetime,
    `updated_at` datetime
)
;
ALTER TABLE `states` ADD CONSTRAINT `continent_id_refs_id_d94b3ddc` FOREIGN KEY (`continent_id`) REFERENCES `continents` (`id`);
CREATE TABLE `in_states` (
    `id` integer NOT NULL PRIMARY KEY,
    `location_id` integer,
    `state_id` integer,
    `start_year` integer,
    `end_year` integer,
    `notes` longtext NOT NULL,
    `created_at` datetime,
    `updated_at` datetime
)
;
ALTER TABLE `in_states` ADD CONSTRAINT `state_id_refs_id_1440618c` FOREIGN KEY (`state_id`) REFERENCES `states` (`id`);
ALTER TABLE `in_states` ADD CONSTRAINT `location_id_refs_id_d7966733` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`);
CREATE TABLE `empires` (
    `id` integer NOT NULL PRIMARY KEY,
    `name` varchar(765) NOT NULL,
    `notes` longtext NOT NULL,
    `created_at` datetime,
    `updated_at` datetime
)
;
CREATE TABLE `in_empires` (
    `id` integer NOT NULL PRIMARY KEY,
    `state_id` integer,
    `empire_id` integer,
    `start_year` integer,
    `end_year` integer,
    `notes` longtext NOT NULL,
    `created_at` datetime,
    `updated_at` datetime
)
;
ALTER TABLE `in_empires` ADD CONSTRAINT `state_id_refs_id_54285b6e` FOREIGN KEY (`state_id`) REFERENCES `states` (`id`);
ALTER TABLE `in_empires` ADD CONSTRAINT `empire_id_refs_id_3163f3de` FOREIGN KEY (`empire_id`) REFERENCES `empires` (`id`);
CREATE TABLE `individuals` (
    `id` integer NOT NULL PRIMARY KEY,
    `name` varchar(765) NOT NULL,
    `sex` varchar(765) NOT NULL,
    `birth_date` date,
    `death_date` date,
    `state_id` integer,
    `notes` longtext NOT NULL,
    `created_at` datetime,
    `updated_at` datetime,
    `sort_name` varchar(765) NOT NULL,
    `american` bool,
    `birth_day_known` bool,
    `birth_month_known` bool,
    `birth_year_known` bool,
    `death_day_known` bool,
    `death_month_known` bool,
    `death_year_known` bool
)
;
ALTER TABLE `individuals` ADD CONSTRAINT `state_id_refs_id_886874b8` FOREIGN KEY (`state_id`) REFERENCES `states` (`id`);
CREATE TABLE `residence_types` (
    `id` integer NOT NULL PRIMARY KEY,
    `name` varchar(765) NOT NULL,
    `temporary` bool,
    `notes` longtext NOT NULL,
    `created_at` datetime,
    `updated_at` datetime
)
;
CREATE TABLE `residences` (
    `id` integer NOT NULL PRIMARY KEY,
    `individual_id` integer,
    `location_id` integer,
    `residence_type_id` integer,
    `start_year` integer,
    `end_year` integer,
    `birth_place` bool,
    `death_place` bool,
    `notes` longtext NOT NULL,
    `created_at` datetime,
    `updated_at` datetime
)
;
ALTER TABLE `residences` ADD CONSTRAINT `location_id_refs_id_bc86d2b1` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`);
ALTER TABLE `residences` ADD CONSTRAINT `residence_type_id_refs_id_ef49a9bd` FOREIGN KEY (`residence_type_id`) REFERENCES `residence_types` (`id`);
ALTER TABLE `residences` ADD CONSTRAINT `individual_id_refs_id_323407f5` FOREIGN KEY (`individual_id`) REFERENCES `individuals` (`id`);
CREATE TABLE `occupation_types` (
    `id` integer NOT NULL PRIMARY KEY,
    `name` varchar(765) NOT NULL,
    `notes` longtext NOT NULL,
    `created_at` datetime,
    `updated_at` datetime
)
;
CREATE TABLE `occupation_titles` (
    `id` integer NOT NULL PRIMARY KEY,
    `name` varchar(765) NOT NULL,
    `occupation_type_id` integer,
    `notes` longtext NOT NULL,
    `created_at` datetime,
    `updated_at` datetime
)
;
ALTER TABLE `occupation_titles` ADD CONSTRAINT `occupation_type_id_refs_id_f702fa2` FOREIGN KEY (`occupation_type_id`) REFERENCES `occupation_types` (`id`);
CREATE TABLE `occupations` (
    `id` integer NOT NULL PRIMARY KEY,
    `individual_id` integer,
    `occupation_title_id` integer,
    `start_year` integer,
    `end_year` integer,
    `notes` longtext NOT NULL,
    `created_at` datetime,
    `updated_at` datetime
)
;
ALTER TABLE `occupations` ADD CONSTRAINT `occupation_title_id_refs_id_32d8df30` FOREIGN KEY (`occupation_title_id`) REFERENCES `occupation_titles` (`id`);
ALTER TABLE `occupations` ADD CONSTRAINT `individual_id_refs_id_4756e4d1` FOREIGN KEY (`individual_id`) REFERENCES `individuals` (`id`);
CREATE TABLE `relationship_types` (
    `id` integer NOT NULL PRIMARY KEY,
    `name` varchar(765) NOT NULL,
    `notes` longtext NOT NULL,
    `created_at` datetime,
    `updated_at` datetime
)
;
CREATE TABLE `relationships` (
    `id` integer NOT NULL PRIMARY KEY,
    `individual_id_1` integer,
    `individual_id_2` integer,
    `relationship_type_id` integer,
    `start_year` integer,
    `end_year` integer,
    `notes` longtext NOT NULL,
    `created_at` datetime,
    `updated_at` datetime
)
;
ALTER TABLE `relationships` ADD CONSTRAINT `relationship_type_id_refs_id_badf35b` FOREIGN KEY (`relationship_type_id`) REFERENCES `relationship_types` (`id`);
ALTER TABLE `relationships` ADD CONSTRAINT `individual_id_1_refs_id_7c3d76a` FOREIGN KEY (`individual_id_1`) REFERENCES `individuals` (`id`);
ALTER TABLE `relationships` ADD CONSTRAINT `individual_id_2_refs_id_7c3d76a` FOREIGN KEY (`individual_id_2`) REFERENCES `individuals` (`id`);
CREATE TABLE `assignment_types` (
    `id` integer NOT NULL PRIMARY KEY,
    `name` varchar(765) NOT NULL,
    `notes` longtext NOT NULL,
    `created_at` datetime,
    `updated_at` datetime
)
;
CREATE TABLE `assignment_titles` (
    `id` integer NOT NULL PRIMARY KEY,
    `name` varchar(765) NOT NULL,
    `assignment_type_id` integer,
    `temporary` bool,
    `commissioned` bool,
    `notes` longtext NOT NULL,
    `created_at` datetime,
    `updated_at` datetime
)
;
ALTER TABLE `assignment_titles` ADD CONSTRAINT `assignment_type_id_refs_id_69d2800a` FOREIGN KEY (`assignment_type_id`) REFERENCES `assignment_types` (`id`);
CREATE TABLE `assignments` (
    `id` integer NOT NULL PRIMARY KEY,
    `individual_id` integer,
    `assignment_title_id` integer,
    `location_id` integer,
    `start_year` integer,
    `start_certain` bool,
    `end_year` integer,
    `end_certain` bool,
    `notes` longtext NOT NULL
)
;
ALTER TABLE `assignments` ADD CONSTRAINT `location_id_refs_id_ad0e3939` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`);
ALTER TABLE `assignments` ADD CONSTRAINT `assignment_title_id_refs_id_f46ec2d4` FOREIGN KEY (`assignment_title_id`) REFERENCES `assignment_titles` (`id`);
ALTER TABLE `assignments` ADD CONSTRAINT `individual_id_refs_id_37afe27d` FOREIGN KEY (`individual_id`) REFERENCES `individuals` (`id`);
CREATE TABLE `organization_types` (
    `id` integer NOT NULL PRIMARY KEY,
    `name` varchar(765) NOT NULL,
    `notes` longtext NOT NULL,
    `created_at` datetime,
    `updated_at` datetime
)
;
CREATE TABLE `organizations` (
    `id` integer NOT NULL PRIMARY KEY,
    `name` varchar(765) NOT NULL,
    `start_year` integer,
    `end_year` integer,
    `magazine_sending` bool,
    `organization_type_id` integer,
    `location_id` integer,
    `org_bio` longtext NOT NULL,
    `notes` longtext NOT NULL,
    `created_at` datetime,
    `updated_at` datetime
)
;
ALTER TABLE `organizations` ADD CONSTRAINT `location_id_refs_id_22e21ea9` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`);
ALTER TABLE `organizations` ADD CONSTRAINT `organization_type_id_refs_id_abd934b` FOREIGN KEY (`organization_type_id`) REFERENCES `organization_types` (`id`);
CREATE TABLE `org_evolution_types` (
    `id` integer NOT NULL PRIMARY KEY,
    `name` varchar(765) NOT NULL,
    `notes` longtext NOT NULL,
    `created_at` datetime,
    `updated_at` datetime
)
;
CREATE TABLE `org_evolutions` (
    `id` integer NOT NULL PRIMARY KEY,
    `org_1_id` integer,
    `org_2_id` integer,
    `org_evolution_type_id` integer,
    `date` date,
    `notes` longtext NOT NULL,
    `created_at` datetime,
    `updated_at` datetime,
    `day_known` bool,
    `month_known` bool,
    `year_known` bool
)
;
ALTER TABLE `org_evolutions` ADD CONSTRAINT `org_evolution_type_id_refs_id_6ed0ab53` FOREIGN KEY (`org_evolution_type_id`) REFERENCES `org_evolution_types` (`id`);
ALTER TABLE `org_evolutions` ADD CONSTRAINT `org_1_id_refs_id_3903a6e1` FOREIGN KEY (`org_1_id`) REFERENCES `organizations` (`id`);
ALTER TABLE `org_evolutions` ADD CONSTRAINT `org_2_id_refs_id_3903a6e1` FOREIGN KEY (`org_2_id`) REFERENCES `organizations` (`id`);
CREATE TABLE `role_types` (
    `id` integer NOT NULL PRIMARY KEY,
    `name` varchar(765) NOT NULL,
    `notes` longtext NOT NULL,
    `created_at` datetime,
    `updated_at` datetime
)
;
CREATE TABLE `role_titles` (
    `id` integer NOT NULL PRIMARY KEY,
    `name` varchar(765) NOT NULL,
    `role_type_id` integer,
    `notes` longtext NOT NULL,
    `created_at` datetime,
    `updated_at` datetime
)
;
ALTER TABLE `role_titles` ADD CONSTRAINT `role_type_id_refs_id_6b60065e` FOREIGN KEY (`role_type_id`) REFERENCES `role_types` (`id`);
CREATE TABLE `members` (
    `id` integer NOT NULL PRIMARY KEY,
    `individual_id` integer,
    `organization_id` integer,
    `role_title_id` integer,
    `start_year` integer,
    `end_year` integer,
    `notes` longtext NOT NULL,
    `created_at` datetime,
    `updated_at` datetime
)
;
ALTER TABLE `members` ADD CONSTRAINT `organization_id_refs_id_6869fae6` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`);
ALTER TABLE `members` ADD CONSTRAINT `role_title_id_refs_id_cb6a5afe` FOREIGN KEY (`role_title_id`) REFERENCES `role_titles` (`id`);
ALTER TABLE `members` ADD CONSTRAINT `individual_id_refs_id_cfaaf50` FOREIGN KEY (`individual_id`) REFERENCES `individuals` (`id`);
CREATE TABLE `letters` (
    `id` integer NOT NULL PRIMARY KEY,
    `from_individual_id` integer,
    `from_organization_id` integer,
    `from_location_id` integer,
    `to_individual_id` integer,
    `to_organization_id` integer,
    `to_location_id` integer,
    `circular` bool,
    `date_sent` date,
    `date_received` date,
    `date_docketed` date,
    `notes` longtext NOT NULL,
    `title` varchar(765) NOT NULL,
    `sent_day_known` bool,
    `sent_month_known` bool,
    `sent_year_known` bool,
    `received_day_known` bool,
    `received_month_known` bool,
    `received_year_known` bool,
    `docketed_day_known` bool,
    `docketed_month_known` bool,
    `docketed_year_known` bool,
    `created_at` datetime,
    `updated_at` datetime
)
;
ALTER TABLE `letters` ADD CONSTRAINT `from_organization_id_refs_id_ed2bb024` FOREIGN KEY (`from_organization_id`) REFERENCES `organizations` (`id`);
ALTER TABLE `letters` ADD CONSTRAINT `to_organization_id_refs_id_ed2bb024` FOREIGN KEY (`to_organization_id`) REFERENCES `organizations` (`id`);
ALTER TABLE `letters` ADD CONSTRAINT `from_location_id_refs_id_ceb7d1b0` FOREIGN KEY (`from_location_id`) REFERENCES `locations` (`id`);
ALTER TABLE `letters` ADD CONSTRAINT `to_location_id_refs_id_ceb7d1b0` FOREIGN KEY (`to_location_id`) REFERENCES `locations` (`id`);
ALTER TABLE `letters` ADD CONSTRAINT `from_individual_id_refs_id_80ace46` FOREIGN KEY (`from_individual_id`) REFERENCES `individuals` (`id`);
ALTER TABLE `letters` ADD CONSTRAINT `to_individual_id_refs_id_80ace46` FOREIGN KEY (`to_individual_id`) REFERENCES `individuals` (`id`);
CREATE TABLE `enclosures` (
    `id` integer NOT NULL PRIMARY KEY,
    `main_letter_id` integer,
    `enclosed_letter_id` integer,
    `notes` longtext NOT NULL,
    `created_at` datetime,
    `updated_at` datetime
)
;
ALTER TABLE `enclosures` ADD CONSTRAINT `main_letter_id_refs_id_5aaaba7e` FOREIGN KEY (`main_letter_id`) REFERENCES `letters` (`id`);
ALTER TABLE `enclosures` ADD CONSTRAINT `enclosed_letter_id_refs_id_5aaaba7e` FOREIGN KEY (`enclosed_letter_id`) REFERENCES `letters` (`id`);
CREATE TABLE `bibliographies` (
    `id` integer NOT NULL PRIMARY KEY,
    `entry` longtext NOT NULL,
    `notes` longtext NOT NULL,
    `created_at` datetime,
    `updated_at` datetime
)
;
CREATE TABLE `citations` (
    `id` integer NOT NULL PRIMARY KEY,
    `title` varchar(765) NOT NULL,
    `bibliography_id` integer,
    `pages` varchar(765) NOT NULL,
    `canonic_url` varchar(765) NOT NULL,
    `notes` longtext NOT NULL,
    `created_at` datetime,
    `updated_at` datetime
)
;
ALTER TABLE `citations` ADD CONSTRAINT `bibliography_id_refs_id_1e2256a` FOREIGN KEY (`bibliography_id`) REFERENCES `bibliographies` (`id`);
CREATE TABLE `validations` (
    `id` integer NOT NULL PRIMARY KEY,
    `auth_user_id` integer,
    `content_type_id` integer NOT NULL,
    `object_id` integer UNSIGNED NOT NULL,
    `supports` bool,
    `citation_id` integer,
    `notes` longtext NOT NULL,
    `created_at` datetime,
    `updated_at` datetime
)
;
ALTER TABLE `validations` ADD CONSTRAINT `auth_user_id_refs_id_38bc12fb` FOREIGN KEY (`auth_user_id`) REFERENCES `auth_user` (`id`);
ALTER TABLE `validations` ADD CONSTRAINT `citation_id_refs_id_7d0cc423` FOREIGN KEY (`citation_id`) REFERENCES `citations` (`id`);
ALTER TABLE `validations` ADD CONSTRAINT `content_type_id_refs_id_c988d747` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);
COMMIT;
