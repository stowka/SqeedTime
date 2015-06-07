//
//  CreateSqeedViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 21/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "CreateSqeedViewController.h"
#import "CacheHandler.h"
#import "UIImage+ImageEffects.h"

#import "ModalWhatViewController.h"
#import "ModalWhenViewController.h"
#import "ModalWhereViewController.h"
#import "ModalWhoViewController.h"

#import "SuggestionTableViewCell.h"
#import "AlertHelper.h"

@interface CreateSqeedViewController ()

@end

NSDictionary* categories;

@implementation CreateSqeedViewController
@synthesize whatLabel;
@synthesize whenLabel;
@synthesize whereLabel;
@synthesize whoLabel;
@synthesize autocompleteTableView;
@synthesize nextButton;
@synthesize lsw;
@synthesize rsw;

@synthesize allSuggestions;
@synthesize suggestions;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self whatToDoTextField] setText:@""];
    
    // Add observers to update labels
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePlaceLabel)
                                                 name:@"ModalPlaceDidChange"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePeopleMaxLabel)
                                                 name:@"ModalPeopleMaxDidChange"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateDescriptionLabel)
                                                 name:@"ModalDescriptionDidChange"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateDateLabel)
                                                 name:@"ModalDateDidChange"
                                               object:nil];
    
    // Autocomplete suggestion
    allSuggestions = @[@"Athlétisme",
                       @"Arts martiaux",
                       @"Aviron",
                       @"Anniversaire",
                       @"Accro-branches",
                       @"Américain",
                       @"Anni",
                       @"Airsoft",
                       @"Aquapark",
                       @"Afterwork",
                       @"After dinner",
                       @"Apéro",
                       @"Balade",
                       @"BBQ",
                       @"Barbecue",
                       @"Bouffe",
                       @"Burger",
                       @"Beach",
                       @"Ballade",
                       @"Bière-pong",
                       @"Bains",
                       @"Bateau",
                       @"Bronzette",
                       @"Bains Thermaux",
                       @"Badmington",
                       @"Baseball",
                       @"Braserade",
                       @"Biblio",
                       @"Bibliothèque",
                       @"Buzz",
                       @"Boom",
                       @"Barathon<",
                       @"Bridge",
                       @"Bière",
                       @"Bowling",
                       @"Boxe",
                       @"Carte",
                       @"Casino",
                       @"Café",
                       @"Chibre",
                       @"Condition physique",
                       @"Canoë",
                       @"Canyoning",
                       @"Capoeira",
                       @"Croisière",
                       @"Chinois",
                       @"Cheval",
                       @"Citygolf",
                       @"Cinéma",
                       @"Cirque",
                       @"Cuisine",
                       @"Curling",
                       @"Course à pied",
                       @"Danse",
                       @"Dîner",
                       @"Dîner de cons",
                       @"Dimanche soir",
                       @"Digestif",
                       @"Escalade",
                       @"Escrime",
                       @"Excursion",
                       @"Entrainement",
                       @"Equitation",
                       @"Foot",
                       @"Football",
                       @"Football américain",
                       @"Fondue",
                       @"Fitness",
                       @"Fiesta",
                       @"Fiesta Cabana",
                       @"Fifa",
                       @"Golf",
                       @"Go Dancefloor",
                       @"Gymnastique",
                       @"Hockey",
                       @"Hackaton",
                       @"Indien",
                       @"Judo",
                       @"Jeudi soir",
                       @"Jeu de carte",
                       @"Jeu de société",
                       @"Jeu de l’oie",
                       @"Jogging",
                       @"Jardinage",
                       @"Karting",
                       @"Laser game",
                       @"Lac",
                       @"Luge",
                       @"LHC",
                       @"Lunch",
                       @"Lundi soir",
                       @"Mardi tout est permis",
                       @"Mercredi tout est permis",
                       @"Meeting",
                       @"Marche",
                       @"Match",
                       @"Minigolf",
                       @"Midi",
                       @"Musée",
                       @"Mardi soir",
                       @"Murge",
                       @"Natation",
                       @"Night",
                       @"Niole",
                       @"Nouvel an",
                       @"Nordic-walking",
                       @"Opéra",
                       @"Patrouille",
                       @"Pakistané",
                       @"Peau de phoque",
                       @"Promenade",
                       @"Pause",
                       @"Party",
                       @"Patinoire",
                       @"Parcours vita",
                       @"Pendaison de crémaillaire",
                       @"Pelote basque",
                       @"Piscine",
                       @"Place-de-jeux",
                       @"Pierrade",
                       @"Plage",
                       @"Playa",
                       @"Pétée",
                       @"Plongée",
                       @"Peau de phoque",
                       @"Pêche",
                       @"Pêche au gros",
                       @"Partie de foot",
                       @"Pétanque",
                       @"Playstation",
                       @"Poker",
                       @"Ping-pong",
                       @"Randonnée",
                       @"Repas",
                       @"Ra",
                       @"Resto",
                       @"Resto chinois",
                       @"Réunion",
                       @"Rafting",
                       @"Ski",
                       @"Skate",
                       @"Samedi soir",
                       @"Safari",
                       @"Snowboard",
                       @"Snorkeling",
                       @"Souper",
                       @"Soir",
                       @"Soirée",
                       @"Shopping",
                       @"Soirée télé",
                       @"Soirée Foot",
                       @"Soirée Champions",
                       @"Soirée Match",
                       @"Soirée series",
                       @"Sortie bateau",
                       @"Sushis",
                       @"Softball",
                       @"Séries",
                       @"Séminaire",
                       @"Swin-Golf",
                       @"Tournoi",
                       @"Théatre",
                       @"Taekwendo",
                       @"Tarot",
                       @"Tennis",
                       @"Team building",
                       @"Tennis de table",
                       @"Travail de groupe",
                       @"Travail de séminaire",
                       @"Tir",
                       @"trampoline",
                       @"Voile",
                       @"Vélo",
                       @"Vendredi soir",
                       @"Week-end",
                       @"Waterpolo",
                       @"Yoga",
                       @"Zumba",
                       @"Zoo",
                       @"5 vs 5"];
    
    [autocompleteTableView setScrollEnabled:YES];
    [autocompleteTableView setHidden:YES];
    suggestions = [[NSMutableArray alloc] init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [suggestions count];
}

- (UITableViewCell *)tableView:(UITableView *)suggestionTableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Setup cell identifier
    static NSString *cellIdentifier = @"cellSuggestionID";
    
    SuggestionTableViewCell *cell = [suggestionTableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [[cell title] setText:[NSString stringWithFormat:@"%@", suggestions[indexPath.row]]];
    return cell;
}

// AUTOCOMPLETE
- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    [autocompleteTableView setHidden:NO];
    
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring
                 stringByReplacingCharactersInRange:range withString:string];
    [self searchAutocompleteEntriesWithSubstring:substring];
    return YES;
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    [suggestions removeAllObjects];
    for(NSString *curString in allSuggestions) {
        NSRange substringRange = [curString rangeOfString:substring];
        if (substringRange.location == 0) {
            [suggestions addObject:curString];
        }
    }

    if (0 == [suggestions count]) {
        [autocompleteTableView setHidden:YES];
    }
    [autocompleteTableView reloadData];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [autocompleteTableView setHidden:YES];
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    if (0 == section)
        return @"Suggestions";
    else
        return @"";
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_whatToDoTextField setText:suggestions[[indexPath row]]];
    [[[CacheHandler instance] createSqeed] setTitle:suggestions[[indexPath row]]];
    [autocompleteTableView setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [[[CacheHandler instance] categories] count] + 1;
}

- (NSString*)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return row == 0 ? @"Pick a category" : (NSString*)[[[CacheHandler instance] categories][row - 1] label];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [_whatToDoTextField resignFirstResponder];
    
    if ([[CacheHandler instance] editing]) {
        if (0 != row)
            [[[CacheHandler instance] editSqeed] setSqeedCategory:[[SqeedCategory alloc] initWithIndex:((int)row - 1)]];
    } else {
        if (0 != row)
            [[[CacheHandler instance] createSqeed] setSqeedCategory:[[SqeedCategory alloc] initWithIndex:((int)row - 1)]];
    }
}

- (IBAction)backgroundClick:(id)sender {
    [_whatToDoTextField resignFirstResponder];
}

- (IBAction)saveToCache:(id)sender {
    [[[CacheHandler instance] createSqeed] setTitle:[[self whatToDoTextField] text]];
}

- (IBAction)cancel:(id)sender {
}

- (IBAction)saveEdit:(id)sender {
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"segueAddFriends"])
        if ((![[_whatToDoTextField text] isEqualToString:@""] && [_categoryPickerView selectedRowInComponent:0])) {
            return YES;
        } else {
            [AlertHelper alert:@"You must at least set a title and choose a category." :@"Warning"];
            return NO;
        }
    else {
        return YES;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIImage* imageOfUnderlyingView = [UIImage imageNamed:@"blurbg.jpg"];
    imageOfUnderlyingView = [imageOfUnderlyingView applyBlurWithRadius:30
                                                             tintColor:[UIColor colorWithWhite:1.0 alpha:0.3]
                                                 saturationDeltaFactor:1.3
                                                             maskImage:nil];
    if ([[segue identifier] isEqualToString:@"segueWhen"]) {
        if (![[CacheHandler instance] editing]) {
            ModalWhenViewController* destViewController = [segue destinationViewController];
            [destViewController setImageOfUnderlyingView:imageOfUnderlyingView];
        }
    }
    if ([[segue identifier] isEqualToString:@"segueWhere"]) {
        ModalWhereViewController* destViewController = [segue destinationViewController];
        [destViewController setImageOfUnderlyingView:imageOfUnderlyingView];
    }
    if ([[segue identifier] isEqualToString:@"segueWho"]) {
        ModalWhoViewController* destViewController = [segue destinationViewController];
        [destViewController setImageOfUnderlyingView:imageOfUnderlyingView];
    }
    if ([[segue identifier] isEqualToString:@"segueWhat"]) {
        ModalWhatViewController* destViewController = [segue destinationViewController];
        [destViewController setImageOfUnderlyingView:imageOfUnderlyingView];
    }
}

- (void) updatePlaceLabel {
    if ([[CacheHandler instance] editing]) {
        if ([[[[CacheHandler instance] editSqeed] place] isEqualToString:@""])
            [whereLabel setText :@"Place"];
        else
            [whereLabel setText :[[[CacheHandler instance] editSqeed] place]];
    } else {
        if ([[[[CacheHandler instance] createSqeed] place] isEqualToString:@""])
            [whereLabel setText :@"Place"];
        else
            [whereLabel setText :[[[CacheHandler instance] createSqeed] place]];
    }
}

- (void) updatePeopleMaxLabel {
    NSString *peopleLabel = [NSString stringWithFormat:@"%@", [[[CacheHandler instance] createSqeed] peopleMax]];
    [whoLabel setText :peopleLabel];
}

- (void) updateDescriptionLabel {
    if ([[[[CacheHandler instance] createSqeed] sqeedDescription] isEqualToString:@""])
        [whatLabel setText :@"Description"];
    else
        [whatLabel setText :[[[CacheHandler instance] createSqeed] sqeedDescription]];
}

- (void) updateDateLabel {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, HH:mm"];
    [whenLabel setText :[formatter stringFromDate:[[[CacheHandler instance] createSqeed] dateStart]]];
}

- (IBAction)showWherePopUp:(id)sender {
    [_whatToDoTextField resignFirstResponder];
}

- (IBAction)showHowManyPeoplePopUp:(id)sender {
    [_whatToDoTextField resignFirstResponder];
}

- (IBAction)showDescriptionPopUp:(id)sender {
    [_whatToDoTextField resignFirstResponder];
}

- (IBAction)showWhenPopUp:(id)sender {
    [_whatToDoTextField resignFirstResponder];
}

- (IBAction)save:(id)sender {
    [_whatToDoTextField resignFirstResponder];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
