//
//  Deneme.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 26.06.2025.
//

import GRDB

struct Book: Identifiable, Codable, FetchableRecord, MutablePersistableRecord {
    var id: Int64?
    var title: String

    static let databaseTableName = "books"
}

final class DatabaseManager {
    static let shared = DatabaseManager()
    private var dbQueue: DatabaseQueue!

    private init() {
        copyDatabaseIfNeeded()
        setupDatabase()
    }

    /// Copy prebuilt SQLite from bundle to Documents (first launch only)
    private func copyDatabaseIfNeeded() {
        let fm = FileManager.default
        let docsURL = fm.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destURL = docsURL.appendingPathComponent("books.sqlite")
        guard !fm.fileExists(atPath: destURL.path) else { return }
        guard let bundleURL = Bundle.main.url(forResource: "books", withExtension: "sqlite") else {
            print("No bundled DB, will create new on first run.")
            return
        }
        try? fm.copyItem(at: bundleURL, to: destURL)
    }

    private func setupDatabase() {
        let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dbPath = docsURL.appendingPathComponent("books.sqlite").path
        do {
            dbQueue = try DatabaseQueue(path: dbPath)
            try migrator.migrate(dbQueue)
        } catch {
            fatalError("Database setup failed: \(error)")
        }
    }

    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        migrator.registerMigration("createBooks") { db in
            try db.create(table: Book.databaseTableName, ifNotExists: true) { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("title", .text).notNull()
            }
        }
        return migrator
    }

    // MARK: - CRUD

    func fetchBooks() async throws -> [Book] {
        try await dbQueue.read { db in
            try Book.fetchAll(db)
        }
    }

    func addBook(title: String) async throws {
        var book = Book(id: nil, title: title)
        try await dbQueue.write { db in
            try book.insert(db)
        }
    }

    func updateBook(_ book: Book) async throws {
        try await dbQueue.write { db in
            try book.update(db)
        }
    }

    func deleteBook(_ book: Book) async throws {
        try await dbQueue.write { db in
            try book.delete(db)
        }
    }
}

import Foundation

@MainActor
final class BooksViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var newTitle: String = ""

    func loadBooks() async {
        do {
            books = try await DatabaseManager.shared.fetchBooks()
        } catch {
            print("Error loading books: \(error)")
        }
    }

    func addBook() async {
        guard !newTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        do {
            try await DatabaseManager.shared.addBook(title: newTitle)
            newTitle = ""
            await loadBooks()
        } catch {
            print("Error adding book: \(error)")
        }
    }

    func updateBook(_ book: Book, with newTitle: String) async {
        var updatedBook = book
        updatedBook.title = newTitle
        do {
            try await DatabaseManager.shared.updateBook(updatedBook)
            await loadBooks()
        } catch {
            print("Error updating book: \(error)")
        }
    }

    func deleteBook(at offsets: IndexSet) async {
        for index in offsets {
            let book = books[index]
            do {
                try await DatabaseManager.shared.deleteBook(book)
            } catch {
                print("Error deleting book: \(error)")
            }
        }
        await loadBooks()
    }
}

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = BooksViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.books) { book in
                    Text(book.title)
                }
                .onDelete { offsets in
                    Task { await viewModel.deleteBook(at: offsets) }
                }
            }
            .navigationTitle("Books")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        TextField("New book title", text: $viewModel.newTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button("Add") {
                            Task { await viewModel.addBook() }
                        }
                        .disabled(viewModel.newTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                    .padding()
                }
            }
            .task {
                await viewModel.loadBooks()
            }
        }
    }
}
